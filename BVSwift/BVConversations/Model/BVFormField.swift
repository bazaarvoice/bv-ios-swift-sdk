//
//
//  BVFormField.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVFormField type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVFormField: BVAuxiliaryable {
  private let type: String?
  public var formInputType: BVFormInputType {
    return BVFormInputType(rawValue: type)
  }
  public let identifier: String?
  public let isDefault: Bool?
  public let label: String?
  public let maxLength: Int?
  public let minLength: Int?
  public let options: [BVFormFieldOption]?
  public let required: Bool?
  public let value: String?
  
  private enum CodingKeys: String, CodingKey {
    case identifier = "Id"
    case isDefault = "Default"
    case label = "Label"
    case maxLength = "MaxLength"
    case minLength = "MinLength"
    case options = "Options"
    case required = "Required"
    case type = "Type"
    case value = "Value"
  }
}

public struct BVMultiProductFormField: BVAuxiliaryable {
  private let type: String?
  public var formInputType: BVFormInputType {
    return BVFormInputType(rawValue: type)
  }
  public let identifier: String?
  public let isDefault: Bool?
  public let label: String?
  public let classification: String?
  public let maxLength: Int?
  public let minLength: Int?
  public let hidden: Bool?
  public let required: Bool?
  public let autoPopulate: Bool?
  public let value: String?
  public let valuesLabel: [String:String]?
  
  private enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case isDefault = "default"
    case label = "label"
    case classification = "class"
    case maxLength = "maxLength"
    case minLength = "minLength"
    case hidden = "hidden"
    case required = "required"
    case autoPopulate = "autoPopulate"
    case type = "type"
    case value = "value"
    case valuesLabel = "valuesLabel"
  }
}

public struct BVFormFieldError: Codable {
  public let codeString: String?
  public let messageString: String?
  public let name: String?
  
  private enum CodingKeys: String, CodingKey {
    case codeString = "Code"
    case messageString = "Message"
    case name = "Field"
  }
}

extension BVFormFieldError: BVError {
  public var code: String {
    return codeString ?? "Unknown Form Field Error Code"
  }
  
  public var message: String {
    return messageString ?? "Unknown Form Field Error Message"
  }
  
  public var description: String {
    return "Code: \(code) Message: \(message)"
  }
  
  public var debugDescription: String {
    return "Name: \(name ?? "Unknown"), " +
    "Code: \(code), Message: \(message)"
  }
}

public struct BVFormFieldOption: Codable {
  public let label: String?
  public let selected: Bool?
  public let value: String?
  
  private enum CodingKeys: String, CodingKey {
    case label = "Label"
    case selected = "Selected"
    case value = "Value"
  }
}

public enum BVFormInputType {
  case boolean
  case file
  case integer
  case select
  case text
  case textarea
  case unknown
}

internal extension BVFormInputType {
    init(rawValue: String?) {
    switch rawValue {
    case let .some(value) where "BooleanInput" == value:
      self = .boolean
    case let .some(value) where "FileInput" == value:
      self = .file
    case let .some(value) where "IntegerInput" == value:
      self = .integer
    case let .some(value) where "SelectInput" == value:
      self = .select
    case let .some(value) where "TextInput" == value:
      self = .text
    case let .some(value) where "TextAreaInput" == value:
      self = .textarea
    default:
      self = .unknown
    }
  }
}
