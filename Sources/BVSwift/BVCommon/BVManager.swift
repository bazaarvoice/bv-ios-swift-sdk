//
//  BVManager.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The highest abstraction class of this module. This singleton class'
/// intention is to handle all the top level configuration and state management.
/// - Important:
/// \
/// Most of the objects that the BVManager interoperate with don't necessarily
/// need help from it, however, if you don't configure those objects then they
/// will likely fail. Therefore, if you include a configuration file in your
/// project this class will parse it and register the various configurations
/// within itself. These configurations can then be picked up by the BVSwift
/// objects directly by calling through the respective BVManager hooks defined
/// mostly in the extensions provided in each of the submodules.
public class BVManager {
  
  private static var configFileProduction: String = "bvsdk_config_prod"
  private static var configFileStaging: String = "bvsdk_config_staging"
  private static var configFileExtension: String = "json"
  
  private static var production: [String : Any]? = {
    return Bundle.loadJSONFileFromMain(
      name: BVManager.configFileProduction,
      fileExtension: BVManager.configFileExtension)
  }()
  
  private static var staging: [String : Any]? = {
    return Bundle.loadJSONFileFromMain(
      name: BVManager.configFileStaging,
      fileExtension: BVManager.configFileExtension)
  }()
  
  private static var activeFileConfigurationType: BVConfigurationType?
    = {
      
      if let stg = BVManager.staging,
        let clientId: String = stg[apiClientId] as? String {
        return .staging(clientId: clientId)
      }
      
      if let prd = BVManager.production,
        let clientId: String = prd[apiClientId] as? String {
        return .production(clientId: clientId)
      }
      
      return nil
  }()
  
  private var configurations: [BVConfigurationInternal]?
  private var internalURLSession: URLSession =
    BVNetworkingManager.sharedManager.networkingSession
  
  private init() {}
  
  /// Singleton interface
  public static let sharedManager = BVManager()
  
  /// The URLSession object to be used in any networking operations
  public var urlSession: URLSession {
    get {
      return internalURLSession
    }
    set(newValue) {
      internalURLSession = newValue
    }
  }
  
  /// The log level to be used globally
  public var logLevel: BVLogger.BVLogLevel {
    get {
      return BVLogger.sharedLogger.logLevel
    }
    set(newValue) {
      BVLogger.sharedLogger.logLevel = newValue
    }
  }
  
  /// Interface to add configurations to the BVManager
  /// - Parameters:
  ///   - configuration: The BVConfiguration to be added to this manager
  ///
  /// - Note:
  /// \
  /// You can only have one type of configuration enqueued at any one time.
  ///
  /// - Important:
  /// \
  /// This function should be used if using solely programmatic configuration
  /// of the various used modules or to augment the configurations set into the
  /// the file. If any configuration is added programmatically it *will*
  /// overwrite anything in the configuration file. This is an added *feature*
  /// so that it's easier to fluidly and dynamically move from staging to
  /// production and to do so with the granularity of each submodule of BVSwift.
  @discardableResult
  public func addConfiguration(_ configuration: BVConfiguration) -> Self {
    
    guard let internalConfig = configuration as? BVConfigurationInternal else {
      return self
    }
    
    var configs = configurations ?? [BVConfigurationInternal]()
    
    if !configs.contains(where: { (config: BVConfigurationInternal) -> Bool in
      config.isSameTypeAs(internalConfig)
    }) {
      configs.append(internalConfig)
    }
    configurations = configs
    
    return self
  }
}

/// Generic function to search and return a given BVConfiguration. As the
/// BVManager.addConfiguration describes: there can only be one singular type
/// of configuration and it defaults to any that are programmatically added
/// before switching to what is in the configuration file.
internal extension BVManager {
  func getConfiguration<T: BVConfigurationInternal>() -> T? {
    
    if var configList = configurations {
      
      while !configList.isEmpty {
        
        guard let cfg = configList.first else {
          continue
        }
        
        if let cfgType = cfg as? T {
          return cfgType
        }
        
        if let subConfigs = cfg.subConfigurations {
          configList += subConfigs
        }
        
        configList.removeFirst(1)
      }
      
      return nil
    }
    
    guard let active = BVManager.activeFileConfigurationType else {
      return nil
    }
    
    let keyValues = { () -> [String : Any]? in
      switch active {
      case .production:
        return BVManager.production
      case .staging:
        return BVManager.staging
      }
    }()
    
    return T.init(active, keyValues: keyValues)
  }
}
