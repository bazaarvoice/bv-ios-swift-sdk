//
//
//  BVIncentivizedStats.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import UIKit

public enum BVIncentivizedStat: BVQueryStat {
    
    case `true`
    case `false`
    
    public static var statPrefix: String {
        return BVConversationsConstants.BVQueryStat.incentivizedstats
    }
    
    public var description: String {
        return internalDescription
    }
    
}

extension BVIncentivizedStat: BVConversationsQueryValue {
    internal var internalDescription: String {
        switch self {
        case .true:
            return BVConversationsConstants.BVIncentivized.true
        case .false:
            return BVConversationsConstants.BVIncentivized.false
        }
    }
}
