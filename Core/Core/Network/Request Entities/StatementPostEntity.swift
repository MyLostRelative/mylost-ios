//
//  StatementPostEntity.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

public struct StatementPost{
    public init(userID: Int, title: String, description: String, imageUrl: String?, gender: Int?, city: String?, relationType: Int?, bloodType: Int?) {
        self.userID = userID
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.gender = gender
        self.city = city
        self.relationType = relationType
        self.bloodType = bloodType
    }
    
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
    public func toJSON() -> [String: Any] {
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

public struct StatementSearchEntity {
    public init(gender: String, city: String, relationType: String, bloodType: String, fromAge: String, toAge: String, query: String) {
        self.gender = gender
        self.city = city
        self.relationType = relationType
        self.bloodType = bloodType
        self.fromAge = fromAge
        self.toAge = toAge
        self.query = query
    }
    
    let gender: String
    let city: String
    let relationType: String
    let bloodType: String
    let fromAge: String
    let toAge: String
    let query: String
    
    public static var `default` = StatementSearchEntity(gender: "",
                                                 city: "",
                                                 relationType: "",
                                                 bloodType: "",
                                                 fromAge: "",
                                                 toAge: "",
                                                 query: "")
    
    public static func getWithQuery(query: String) -> Self {
        StatementSearchEntity(gender: "",
                              city: "",
                              relationType: "",
                              bloodType: "",
                              fromAge: "",
                              toAge: "",
                              query: query)
    }
}
