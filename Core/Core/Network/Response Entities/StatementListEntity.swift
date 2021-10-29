//
//  StatementListEntity.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import Foundation

public struct StatementsListResponse: Codable {
    let result: [StatementResponse]?
}

public struct StatementResponse: Codable {
    let id: Int?
    let userID: Int?
    let title: String?
    let description: String?
    let imageUrl: String?
    let gender: String?
    let city: String?
    let relationType: String?
    let bloodType: String?
    let createDate: String?
}

public enum Gender: String {
  case male
  case female
  case other
    
    public var value: String {
        switch self {
        case .male:
            return "მამრობითი"
        case .female:
            return "მდედრობითი"
        case .other:
            return "უცნობია"
        }
    }
}

public enum BloodType: String {
  case a
  case b
  case ab
  case o
}

public enum RelationType: String {
    case mother
    case father
    case sister
    case brother
    case friend
    case daughter
    case son
    case other
    
    public var value: String {
        switch self {
        case .mother:
            return "დედა"
        case .father:
            return "მამა"
        case .sister:
            return "და"
        case .brother:
            return "ძმა"
        case .daughter:
            return "ქალიშვილი"
        case .son:
            return "ვაჟიშვილი"
            
        case .other:
           return "უცნობია"
        case .friend:
            return "მეგობარი"
        }
    }
}

public struct Statement {
    public let id: Int
    public let userID: Int
    public let statementTitle: String
    public let statementDescription: String
    public let imageUrl: String?
    public let gender: Gender?
    public let city: String?
    public let relationType: RelationType?
    public let bloodType: BloodType?
    public let createDate: String?
    public let isFavourite: Bool?
}

extension StatementsListResponse {
    public func getStatement() -> [Statement] {
        guard let result = result else {return []}
        return result.compactMap { (response) -> Statement? in
            guard let id = response.id,
                  let userID = response.userID,
                  let statementTitle = response.title,
                  let statementDescription = response.description else {return nil}
            return Statement(id: id,
                             userID: userID,
                             statementTitle: statementTitle,
                             statementDescription: statementDescription,
                             imageUrl: response.imageUrl,
                             gender: Gender(rawValue: response.gender ?? ""),
                             city: response.city,
                             relationType: RelationType(rawValue: response.relationType ?? ""),
                             bloodType: BloodType(rawValue: response.bloodType ?? ""),
                             createDate: response.createDate,
                             isFavourite: false)
        } 
    }
}

extension Statement: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
            lhs.statementDescription == rhs.statementDescription &&
            lhs.userID == rhs.userID &&
            lhs.statementTitle == rhs.statementTitle
    }
}
