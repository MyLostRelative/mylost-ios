//
//  BlogListEntity.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Foundation

public struct BlogListResponse: Codable{
    let result: [BlogResponse]?
}

public struct BlogResponse: Codable{
    let id: Int?
    let title: String?
    let description: String?
    let imageUrl: String?
    let createDate: String?
}

public struct Blog{
    public let id: Int
    public let statementTitle: String
    public let statementDescription: String
    public let imageUrl: String?
    public let createDate: String?
    public let isReaded: Bool
    
    public init(id: Int, statementTitle: String, statementDescription: String, imageUrl: String?, createDate: String?, isReaded: Bool) {
        self.id = id
        self.statementTitle = statementTitle
        self.statementDescription = statementDescription
        self.imageUrl = imageUrl
        self.createDate = createDate
        self.isReaded = isReaded
    }
}

extension BlogListResponse {
    func getBlog() -> [Blog]{
        guard let result = result else {return []}
        return result.compactMap { (response) -> Blog? in
            guard let id = response.id,
                  let title = response.title,
                  let description = response.description else {return nil}
            return Blog(id: id,
                        statementTitle: title,
                        statementDescription: description,
                        imageUrl: response.imageUrl,
                        createDate: response.createDate,
                        isReaded: false)
        }
    }
}

extension Blog: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
            lhs.statementDescription == rhs.statementDescription &&
            lhs.statementTitle == rhs.statementTitle
    }
}
