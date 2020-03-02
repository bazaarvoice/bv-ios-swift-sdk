//
//
//  BVURLCacheManager.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVURLCacheToken: Hashable {
  fileprivate let id: String = UUID().uuidString
  fileprivate let expirationInSeconds: TimeInterval
  fileprivate init(expirationInSeconds: TimeInterval = 60.0) {
    self.expirationInSeconds = expirationInSeconds
  }
}

internal class BVURLCacheManager {
  
  private static var defaultCacheSize: Int = (2 * 1024 * 1024)
  private static var cacheDataKey: String =
  "com.bvswift.BVURLCacheManager.cacheDataKey"
  private static var queueKey: DispatchSpecificKey<URLCache> =
    DispatchSpecificKey<URLCache>()
  
  private var nestedCache: [BVURLCacheToken: DispatchQueue] = [:]
  
  private var listeners = [BVURLCacheNotifier]()
  
  private var listenerQueue =
    DispatchQueue(label: "com.bvswift.BVURLCacheManager.listenerQueue")
  
  private var expirationTime: TimeInterval = 60.0
  
  private var sharedCache: URLCache =
    URLCache(
      memoryCapacity: defaultCacheSize,
      diskCapacity: 0,
      diskPath: "com.bvswift.BVURLCacheManager.sharedCache")
  
  private var concurrentSharedQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVURLCacheManager.concurrentSharedQueue",
      qos: .utility,
      attributes: .concurrent,
      autoreleaseFrequency: .inherit,
      target: nil)
  
  private var concurrentFragmentQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVURLCacheManager.concurrentFragmentQueue",
      qos: .utility,
      attributes: .concurrent,
      autoreleaseFrequency: .inherit,
      target: nil)
  
  private init() {}
  
  internal static let shared = BVURLCacheManager()
}

// MARK: - Main Implementation
extension BVURLCacheManager {
  internal var expirationTimeInSeconds: TimeInterval {
    get {
      var exp: TimeInterval = 0.0
      concurrentSharedQueue.sync(flags: .barrier) {
        exp = expirationTime
      }
      return exp
    }
    set(newValue) {
      concurrentSharedQueue.sync(flags: .barrier) {
        expirationTime = newValue
      }
    }
  }
  
  internal func purgeFragment(_ token: BVURLCacheToken) {
    concurrentFragmentQueue.async(flags: .barrier) {
      if let queue = self.nestedCache[token] {
        queue.async {
          if let cache = queue.getSpecific(key: BVURLCacheManager.queueKey) {
            cache.removeAllCachedResponses()
          }
        }
      }
    }
  }
  
  internal func purgeCache(_ includingFragments: Bool = false) {
    concurrentSharedQueue.async(flags: .barrier) {
      self.sharedCache.removeAllCachedResponses()
    }
    
    if includingFragments {
      concurrentFragmentQueue.async(flags: .barrier) {
        self.nestedCache.values.forEach { queue in
          queue.async {
            if let cache = queue.getSpecific(key: BVURLCacheManager.queueKey) {
              cache.removeAllCachedResponses()
            }
          }
        }
      }
    }
  }
  
  internal func acquireCacheFragment(
    memoryCapacity: Int,
    diskCapacity: Int,
    diskPath: String? = nil,
    expirationInSeconds: TimeInterval = 60.0) -> BVURLCacheToken? {
    
    let cache = URLCache(
      memoryCapacity: memoryCapacity,
      diskCapacity: diskCapacity,
      diskPath: diskPath)
    
    var token: BVURLCacheToken?
    
    concurrentFragmentQueue.sync(flags: .barrier) {
      
      let tkn: BVURLCacheToken = {
        var unique: BVURLCacheToken
        repeat {
          unique = BVURLCacheToken(expirationInSeconds: expirationInSeconds)
        } while nestedCache.keys.contains(unique)
        return unique
      }()
      
      let queue =  DispatchQueue(
        label: "com.bvswift.BVURLCacheToken.queue_\(tkn.id)")
      
      queue.setSpecific(key: BVURLCacheManager.queueKey, value: cache)
      
      nestedCache[tkn] = queue
      token = tkn
    }
    
    return token
  }
  
  internal func load(
    _ request: URLRequest,
    token: BVURLCacheToken? = nil) -> CachedURLResponse? {
    
    var response: CachedURLResponse?
    
    if let tkn = token {
      concurrentFragmentQueue.sync {
        guard let queue = nestedCache[tkn] else {
          return
        }
        
        queue.sync {
          
          BVLogger
            .sharedLogger
            .debug("ATTEMPTING CACHE: \(request)")
          
          if let cache = queue.getSpecific(key: BVURLCacheManager.queueKey),
            let hit = cache.cachedResponse(for: request) {
            response = hit
            
            BVLogger
              .sharedLogger
              .debug(
                "LOADING FROM CACHE: \(self.sharedCache.currentMemoryUsage)")
          }
        }
        
      }
    } else {
      concurrentSharedQueue.sync {
        
        BVLogger
          .sharedLogger
          .debug("ATTEMPTING CACHE: \(request)")
        
        if let cached = sharedCache.cachedResponse(for: request) {
          response = cached
          
          BVLogger
            .sharedLogger
            .debug("LOADING FROM CACHE: \(self.sharedCache.currentMemoryUsage)")
        }
      }
    }
    
    notify(request, hit: (nil != response))
    
    return response
  }
  
  internal func store(
    _ cachedResponse: CachedURLResponse,
    request: URLRequest,
    token: BVURLCacheToken? = nil)  {
    
    var userInfo: [AnyHashable: Any] = cachedResponse.userInfo ?? [:]
    userInfo[BVURLCacheManager.cacheDataKey] = Date()
    
    let newCachedResponse =
      CachedURLResponse(
        response: cachedResponse.response,
        data: cachedResponse.data,
        userInfo: userInfo,
        storagePolicy: cachedResponse.storagePolicy)
    
    if let tkn = token {
      concurrentFragmentQueue.async(flags: .barrier) {
        guard let queue = self.nestedCache[tkn] else {
          return
        }
        
        queue.sync {
          if let cache = queue.getSpecific(key: BVURLCacheManager.queueKey) {
            cache.storeCachedResponse(newCachedResponse, for: request)
            
            BVLogger
              .sharedLogger
              .debug("STORING TO CACHE: \(cache.currentMemoryUsage)")
            
            queue.asyncAfter(deadline: .now() + tkn.expirationInSeconds) {
              cache.removeCachedResponse(for: request)
              
              BVLogger
                .sharedLogger
                .debug(
                  "REMOVING FROM CACHE: \(cache.currentMemoryUsage)")
            }
          }
        }
        
      }
    } else {
      concurrentSharedQueue.async(flags: .barrier) {
        
        guard nil == self.sharedCache.cachedResponse(for: request) else {
          fatalError()
        }
        
        self.sharedCache.storeCachedResponse(newCachedResponse, for: request)
        
        BVLogger
          .sharedLogger
          .debug("STORING TO CACHE: \(self.sharedCache.currentMemoryUsage)")
        
        self.concurrentSharedQueue.asyncAfter(
          deadline: .now() + self.expirationTime,
          flags: .barrier) {
            self.sharedCache.removeCachedResponse(for: request)
            
            BVLogger
              .sharedLogger
              .debug(
                "REMOVING FROM CACHE: \(self.sharedCache.currentMemoryUsage)")
        }
      }
    }
  }
}

// MARK: - Testing
internal protocol BVURLCacheListener: AnyObject {
  func hit(_ request: URLRequest)
  func miss(_ request: URLRequest)
}

internal struct BVURLCacheNotifier: Hashable {
  static func == (lhs: BVURLCacheNotifier, rhs: BVURLCacheNotifier) -> Bool {
    return lhs.ptrHash == rhs.ptrHash
  }
  
  private var ptrHash: Int = 0x0
  private let active: () -> Bool
  private let call: (URLRequest, Bool) -> Void
  
  init(_ listener: BVURLCacheListener) {
    active = { [weak listener] () -> Bool in
      return nil != listener
    }
    
    call = { [weak listener] (req: URLRequest, hit: Bool) -> Void in
      if hit {
        listener?.hit(req)
      } else {
        listener?.miss(req)
      }
    }
    
    var inst = listener
    withUnsafePointer(to: &inst) {
      ptrHash = $0.hashValue
    }
  }
  
  var hashValue: Int {
    return ptrHash
  }
  
  internal func isActive() -> Bool {
    return active()
  }
  
  internal func notify(_ request: URLRequest, hit: Bool = false) {
    return call(request, hit)
  }
}

extension BVURLCacheManager {
  func add(_ listener: BVURLCacheListener) {
    listenerQueue.sync {
      let listener = BVURLCacheNotifier(listener)
      if !listeners.contains(listener) {
        listeners.append(listener)
      }
    }
  }
  
  func remove(_ listener: BVURLCacheListener) {
    listenerQueue.sync {
      let notifier = BVURLCacheNotifier(listener)
      listeners = listeners.filter { $0 != notifier && $0.isActive() }
    }
  }
  
  func expunge() {
    listenerQueue.sync {
      listeners.removeAll()
    }
  }
  
  private func notify(_ request: URLRequest, hit: Bool = false) {
    listenerQueue.sync {
      listeners = listeners.filter { $0.isActive() }
      
      listeners.forEach {
        guard hit else {
          
          BVLogger.sharedLogger.debug(
            BVLogMessage(BVConstants.bvProduct, msg: "CACHE MISS: \(request)"))
          
          $0.notify(request)
          return
        }
        
        BVLogger.sharedLogger.debug(BVLogMessage(
          BVConstants.bvProduct, msg: "CACHE HIT: \(request)"))
        
        $0.notify(request, hit: true)
      }
    }
  }
}
