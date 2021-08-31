//
//  StatementListEntity.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import Foundation

struct StatementsListResponse: Codable{
    let result: [StatementResponse]?
}

struct StatementResponse: Codable{
    let id: Int?
    let statement_title: String?
    let statement_description: String?
    let date: Double?
}

struct Statement{
    let id: Int
    let statementTitle: String
    let statementDescription: String
    let date: Double
}

extension StatementsListResponse {
    func getStatement() -> [Statement]{
        guard let result = result else {return []}
        return result.compactMap { (response) -> Statement? in
            guard let id = response.id,
                  let statementTitle = response.statement_title,
                  let statementDescription = response.statement_description,
                  let date = response.date else {return nil}
            return Statement(id: id,
                             statementTitle: statementTitle,
                             statementDescription: statementDescription,
                             date: date)
        }
        
              
    }
}

