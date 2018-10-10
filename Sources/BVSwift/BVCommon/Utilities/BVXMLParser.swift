//
//
//  BVXMLParser.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Really? Really? We need one of these? What year is it?
internal class BVXMLParser: NSObject, XMLParserDelegate {
  
  private var stack: [BVXMLElement]?
  
  override init() { }
  
  func parse(_ data: Data) -> BVXMLElement? {
    let root = BVXMLElement("root")
    stack = [BVXMLElement]()
    stack?.append(root)
    let parser = XMLParser(data: data)
    parser.delegate = self
    parser.parse()
    return root.childElements?.first
  }
  
  func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes attributeDict: [String: String]) {
    
    let node = BVXMLElement(elementName)
    if !attributeDict.isEmpty {
      node.attributes = attributeDict
    }
    
    let parentNode = stack?.last
    
    if nil == parentNode?.childElements {
      parentNode?.childElements = []
    }
    
    parentNode?.childElements?.append(node)
    stack?.append(node)
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    guard let text = stack?.last?.text else {
      stack?.last?.text = string
      return
    }
    stack?.last?.text = text + string
  }
  
  func parser(
    _ parser: XMLParser,
    didEndElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?) {
    stack?.removeLast()
  }
}

internal class BVXMLElement {
  var name: String?
  var text: String?
  var attributes: [String: String]?
  var childElements: [BVXMLElement]?
  
  public init(_ name: String) {
    self.name = name
  }
}

extension BVXMLElement {
  var dictionary: [String: Any]? {
    var insideDictionary: [String: Any] = [:]
    guard let thisName = name else {
      return nil
    }
    guard let children = childElements else {
      guard let thisText = text else {
        return nil
      }
      return [thisName: thisText]
    }
    
    children.forEach {
      insideDictionary += $0.dictionary
    }
    
    return [thisName: insideDictionary]
  }
}
