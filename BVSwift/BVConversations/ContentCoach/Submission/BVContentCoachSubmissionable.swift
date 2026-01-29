//
//
//  BVContentCoachSubmissionable.swift
//  BVSwift
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

import Foundation

///// Enumeration defining the submission type
public enum BVContentCoachSubmissionLocale {
    
    /// The locale for the submission type
    case locale(Locale)
}

/// Protocol defining the ability to accept a
/// BVContentCoachSubmissionLocaleable
public protocol BVContentCoachSubmissionLocaleable {
    @discardableResult
    func add(_ locale: BVContentCoachSubmissionLocale) -> Self
}

@discardableResult
public func <+><T: BVContentCoachSubmissionLocaleable>(
    lhs: T, rhs: BVContentCoachSubmissionLocale?) -> T {
        if let action = rhs {
            lhs.add(action)
        }
        return lhs
    }

// MARK: - BVContentCoachSubmissionParameterable
internal protocol BVContentCoachSubmissionParameterable {
    var urlQueryItems: [URLQueryItem]? { get }
}

// MARK: - BVContentCoachSubmissionPreflightable
internal protocol BVContentCoachSubmissionPreflightable: BVSubmissionActionable {
    func contentCoachSubmissionPreflight(
        _ preflight: BVCompletionWithErrorsHandler?)
}

// MARK: - BVContentCoachSubmissionPostflightable
internal protocol BVContentCoachSubmissionPostflightable: BVSubmissionActionable {
    associatedtype ContentCoachSubmissionPostflightResult: BVSubmissionable
    func contentCoachSubmissionPostflight(
        _ results: [ContentCoachSubmissionPostflightResult]?)
}


/// Protocol defining the ability to accept custom dictionary of strings
public protocol BVContentCoachSubmissionCustomizeable {
    @discardableResult
    func add(_ fields: [String: String]) -> Self
}

@discardableResult
public func <+><T: BVContentCoachSubmissionCustomizeable>(
    lhs: T, rhs: [String: String]?) -> T {
        if let action = rhs {
            lhs.add(action)
        }
        return lhs
    }
// MARK: - BVContentCoachSubmissionLocale: BVContentCoachSubmissionParameterable
extension BVContentCoachSubmissionLocale:
    BVContentCoachSubmissionParameterable {
    var urlQueryItems: [URLQueryItem]? {
        switch self {
        case let .locale(value):
            guard let encoded = value.identifier.urlEncode() else {
                return nil
            }
            return [URLQueryItem(name: "locale", value: encoded)]
        }
    }
}
