//
//  BVUtilities.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extensions

internal func +<Key, Value>
  (lhs: [Key: Value], rhs: [Key: Value]?) -> [Key: Value] {
  guard let right = rhs else {
    return lhs
  }
  var union = lhs
  right.forEach({ union[$0] = $1})
  return union
}

internal func +=<Key, Value>(lhs: inout [Key: Value], rhs: [Key: Value]?) {
  lhs = (lhs + rhs)
}

// swiftlint:disable identifier_name

infix operator <+> : AdditionPrecedence
infix operator ∪ : AdditionPrecedence
infix operator ∪= : AssignmentPrecedence

internal func ∪(lhs: [URLQueryItem]?, rhs: [URLQueryItem]?) -> [URLQueryItem] {
  switch (lhs, rhs) {
  case let (.some(left), .none):
    return left
  case let (.none, .some(right)):
    return right
  case let (.some(left), .some(right)):
    var union = left
    let lhsNames: [String] = left.map { return $0.name }
    right.forEach({ if !lhsNames.contains($0.name) { union.append($0) } })
    return union
  default:
    return []
  }
}

internal func ∪=(lhs: inout [URLQueryItem], rhs: [URLQueryItem]?) {
  lhs = (lhs ∪ rhs)
}

// swiftlint:enable identifier_name

internal func + (lhs: Data, rhs: Data?) -> Data {
  guard let right = rhs else {
    return lhs
  }
  var merge = lhs
  merge.append(right)
  return merge
}

internal func += (lhs: inout Data, rhs: Data?) {
  lhs = (lhs + rhs)
}

internal extension Sequence where Element: Equatable {
  var uniqueElements: [Element] {
    return self.reduce(into: []) {
      uniqueElements, element in
      
      if !uniqueElements.contains(element) {
        uniqueElements.append(element)
      }
    }
  }
}

internal extension Date {
  var toBVFormat: String {
    let df: DateFormatter = DateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    return df.string(from: self)
  }
}

internal extension String {
  static let hex = "0123456789abcdef"
  static let rfc4648 =
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  static let rfc2046 =
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'()+_,-./:=?"
}

internal extension String {
  internal static var empty: String = ""
  
  internal func toBVDate() -> Date? {
    let df: DateFormatter = DateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    return df.date(from: self)
  }
  
  internal func escaping() -> String {
    return self
      .replacingOccurrences(of: ",", with: "\\,")
      .replacingOccurrences(of: ":", with: "\\:")
      .replacingOccurrences(of: "&", with: "%26")
  }
  
  internal func urlEncode() -> String? {
    var set: CharacterSet = CharacterSet.urlQueryAllowed
    set.remove(charactersIn: "+&")
    return addingPercentEncoding(withAllowedCharacters: set)
  }
  
  internal mutating func escape() {
    self = escaping()
  }
}

internal extension String {
  func toUTF8Data() -> Data? {
    return data(using: .utf8)
  }
}

internal extension String {
  static func randomHex(_ length: UInt = 10) -> String {
    let byteCount = Int(length) /// Yep, pedantry, recast to Int
    let align = MemoryLayout<UInt8>.alignment
    let buffer = UnsafeMutableRawPointer.allocate(
      byteCount: byteCount, alignment: align)
    
    defer {
      buffer.deallocate()
    }
    
    if errSecSuccess !=
      SecRandomCopyBytes(kSecRandomDefault, byteCount, buffer) {
      /// We somehow failed here but nonetheless we can fallback to another,
      /// albeit, less desirable entropy source
      arc4random_buf(buffer, byteCount)
    }
    
    let bufferPointer =
      UnsafeRawBufferPointer(start: buffer, count: byteCount)
    
    return bufferPointer.reduce(into: String.empty) {
      $0 += String(format: "%x", $1)
    }
  }
}

internal extension Array where Element: CustomStringConvertible {
  func randomString(_ len: UInt = 1) -> String {
    guard !isEmpty else {
      return String.empty
    }
    return (0..<len).map { _ in return "\(randomElement()!)" }.joined()
  }
}

internal extension Sequence where
Iterator.Element == (key: String, value: String) {
  func toBVURLQueryItems() -> [URLQueryItem] {
    return reduce([]) {
      (result: [URLQueryItem],
      element: (key: String, value: String)) -> [URLQueryItem] in
      
      guard let name = element.key.urlEncode(),
        let urlValue = element.value.urlEncode() else {
          return result
      }
      
      return result + [URLQueryItem(name: name, value: urlValue)]
    }
  }
}

internal extension UnkeyedDecodingContainer {
  internal mutating func decodeArray<T>(_ type: T.Type)
    throws -> [T] where T: Decodable {
      var array: [T] = [T]()
      while !self.isAtEnd {
        let elem: T = try self.decode(T.self)
        array.append(elem)
      }
      return array
  }
}

internal extension URLRequest {
  static func generateBoundary(_ length: UInt = 40) -> String {
    return Array(String.rfc4648).randomString(length)
  }
  
  static func generateKeyValueForData(key: String, data: Data) -> Data? {
    guard !key.isEmpty && !data.isEmpty else {
      return nil
    }
    
    return Data() +
      ("Content-Disposition: form-data; " +
        "name=\"\(key)\"; filename=\"upload\"\r\n").toUTF8Data() +
      "Content-Type: application/octet-stream\r\n\r\n".toUTF8Data() +
      data +
      "\r\n".toUTF8Data()
  }
  
  static func generateKeyValueForString(key: String, string: String) -> Data? {
    guard !key.isEmpty && !string.isEmpty else {
      return nil
    }
    
    return Data() +
      "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".toUTF8Data() +
      string.toUTF8Data() +
      "\r\n".toUTF8Data()
  }
  
  static func encloseMultipartData(
    _ boundary: String?) -> Data? {
    guard let delimiter: String = boundary else {
      fatalError("Invalid boundary value")
    }
    return "--\(delimiter)--\r\n".toUTF8Data()
  }
  
  static func multipartData(
    key: String,
    string: String,
    boundary: String?,
    isLast: Bool = false) -> Data? {
    
    guard let delimiter: String = boundary else {
      fatalError("Invalid boundary value")
    }
    
    var body: Data = Data()
    if let content = generateKeyValueForString(key: key, string: string) {
      body += "--\(delimiter)\r\n".toUTF8Data()
      body += content
    }
    
    if isLast {
      body += encloseMultipartData(delimiter)
    }
    
    return body
  }
  
  static func multipartData(
    key: String,
    data: Data,
    boundary: String?,
    isLast: Bool = false) -> Data? {
    
    var body: Data = Data()
    
    guard let delimiter: String = boundary else {
      fatalError("Invalid boundary value")
    }
    
    if !key.isEmpty && !data.isEmpty {
      if let content = generateKeyValueForData(key: key, data: data) {
        body += "--\(delimiter)\r\n".toUTF8Data()
        body += content
      }
    }
    
    if isLast {
      body += encloseMultipartData(delimiter)
    }
    
    return body
  }
}

internal extension UIImage {
  func resize(_ newSize: CGSize) -> UIImage? {
    let rect: CGRect = CGRect(origin: CGPoint.zero, size: newSize)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
    draw(in: rect)
    let resized: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resized
  }
}

internal extension UIDevice {
  var machine: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    return machineMirror.children.reduce(into: "") {
      guard let value = $1.value as? Int8, value != 0 else {
        return
      }
      $0 += String(UnicodeScalar(UInt8(value)))
    }
  }
}

internal extension Bundle {
  
  class internal var mainBundleIdentifier: String {
    return Bundle.main.bundleIdentifier ?? "unknown"
  }
  
  class internal var releaseVersionNumber: String {
    let error: String = "x.x.x"
    guard let infoDict = self.main.infoDictionary else {
      return error
    }
    
    guard let releaseNumber: String =
      infoDict["CFBundleShortVersionString"] as? String else {
        return error
    }
    
    return releaseNumber
  }
  
  class internal var buildVersionNumber: String {
    let error: String = "-1"
    guard let infoDict = self.main.infoDictionary else {
      return error
    }
    
    guard let versionString = kCFBundleVersionKey as String?,
      let buildNumber: String =
      infoDict[versionString] as? String else {
        return error
    }
    
    return buildNumber
  }
  
  class internal func loadJSONFileFromMain(
    name: String, fileExtension: String) -> [String: Any]? {
    if let path =
      Bundle.main.url(
        forResource: name,
        withExtension: fileExtension),
      let data = try? Data(contentsOf: path),
      let representation =
      try? JSONSerialization.jsonObject(with: data, options: []),
      let json = representation as? [String: Any] {
      return json
    }
    return nil
  }
}

internal extension UIView {
  func walkViewHierarchy<T: UIControl>(
    _ forAll: T,
    addTarget: Any?,
    addTargetSelector: Selector,
    forControlEvents: UIControl.Event = .touchUpInside) {
    
    var subviewQueue: [UIView] = self.subviews
    
    while !subviewQueue.isEmpty {
      let subview = subviewQueue.removeFirst()
      
      if let control = subview as? T {
        control.addTarget(
          addTarget, action: addTargetSelector, for: forControlEvents)
      }
      
      subviewQueue += subview.subviews
    }
  }
}

internal extension UIView {
  func bvGestureRecognizerCheck() {
    guard let gestureRecognizers = gestureRecognizers else {
      return
    }
    
    for recognizer in gestureRecognizers {
      guard recognizer.cancelsTouchesInView else {
        continue
      }
      assert(false, "UIGestureRecognizer must have \"cancelsTouchesInView\" " +
        "set to false for the BVSwift to properly function.")
    }
  }
}

internal extension IndexPath {
  var bvKey: String {
    return "\(section):\(row)"
  }
}
