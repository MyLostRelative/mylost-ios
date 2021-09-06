//
//  StatementPostEntity.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

struct StatementPost{
    let userID: Int
    let title: String
    let description: String
    let imageUrl: String?
    let gender: Int?
    let city: String?
    let relationType: Int?
    let bloodType: Int?
}

extension StatementPost {
    func toJSON() -> [String: Any] {
        var params = ["userID": userID,
                      "title": title,
                      "description": description] as [String : Any]
        if let imageUrl = imageUrl {
            params["imageUrl"] = imageUrl
        }
        if let gender = gender {
            params["gender"] = gender
        }
        if let city = city {
            params["city"] = city
        }
        if let relationType = relationType {
            params["relationType"] = relationType
        }
        if let bloodType = bloodType {
            params["bloodType"] = bloodType
        }
        return params
    }
}
