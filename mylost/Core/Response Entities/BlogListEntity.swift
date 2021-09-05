//
//  BlogListEntity.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Foundation

struct BlogListResponse: Codable{
    let result: [BlogResponse]?
}

struct BlogResponse: Codable{
    let id: Int?
    let title: String?
    let description: String?
    let imageUrl: String?
    let createDate: String?
}

struct Blog{
    let id: Int
    let statementTitle: String
    let statementDescription: String
    let imageUrl: String?
    let createDate: String?
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
                             createDate: response.createDate)
        }
    }
}
