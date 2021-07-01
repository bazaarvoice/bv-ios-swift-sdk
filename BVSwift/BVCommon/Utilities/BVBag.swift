//
//
//  BVBag.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal class BVBag<T> {
  private var dict = [UUID: T]()
  private var array = [UUID]()
  
  internal init() { }
  
  internal func add(_ item: T) -> UUID {
    var uuid: UUID = UUID()
    while array.contains(uuid) {
      uuid = UUID()
    }
    array.append(uuid)
    dict[uuid] = item
    return uuid
  }
  
  internal func remove(_ uuid: UUID) {
    dict[uuid] = nil
    if let idx = array.firstIndex(of: uuid) {
      array.remove(at: idx)
    }
  }
  
  internal func items() -> [T] {
    var returnItems = [T]()
    for uuid in array {
      if let elem = dict[uuid] {
        returnItems.append(elem)
      }
    }
    return returnItems
  }
}
