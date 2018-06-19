//
//
//  BVRecommendationsProfileInclude.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// BVRecommendation list of includable auxiliaryable types for a query
/// - Note:
/// \
/// These are passed as query items to HTTPS requests.
public enum BVRecommendationsProfileInclude: String {
  case brands
  case categories = "category_recommendations"
  case interests
  case recommendations
}
