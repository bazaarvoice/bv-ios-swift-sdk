//
//
//  BVProxyObjectConformance.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

extension BVProxyObject: UICollectionViewDelegate { }

extension BVProxyObject: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    
    let selector: Selector =
      #selector(
        UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))
    
    guard let target =
      target(for: selector) as? UICollectionViewDataSource else {
        let msg: String =
        "BVProxyObject UICollectionViewDataSource shoudn't be called"
        BVLogger.sharedLogger.fault(msg)
        return 0
    }
    return
      target.collectionView(collectionView, numberOfItemsInSection: section)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let selector: Selector =
      #selector(UICollectionViewDataSource.collectionView(_:cellForItemAt:))
    
    guard let target =
      target(for: selector) as? UICollectionViewDataSource else {
        let msg: String =
        "BVProxyObject UICollectionViewDataSource shoudn't be called"
        BVLogger.sharedLogger.fault(msg)
        return UICollectionViewCell()
    }
    return target.collectionView(collectionView, cellForItemAt: indexPath)
  }
}

extension BVProxyObject: UITableViewDelegate { }

extension BVProxyObject: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    let selector: Selector =
      #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))
    
    guard let target = target(for: selector) as? UITableViewDataSource else {
      let msg: String =
      "BVProxyObject UITableViewDataSource shoudn't be called"
      BVLogger.sharedLogger.fault(msg)
      return 0
    }
    return target.tableView(tableView, numberOfRowsInSection: section)
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let selector: Selector =
      #selector(UITableViewDataSource.tableView(_:cellForRowAt:))
    
    guard let target = target(for: selector) as? UITableViewDataSource else {
      let msg: String =
      "BVProxyObject UITableViewDataSource shoudn't be called"
      BVLogger.sharedLogger.fault(msg)
      return UITableViewCell()
    }
    return target.tableView(tableView, cellForRowAt: indexPath)
  }
}
