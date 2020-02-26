//
//
//  BVCurationsSubmissionable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVCurationsSubmissionPostflightable
internal protocol
BVCurationsSubmissionPostflightable: BVSubmissionActionable {
  associatedtype CurationsPostflightResult: BVSubmissionable
  func curationsPostflight(_ results: [CurationsPostflightResult]?)
}
