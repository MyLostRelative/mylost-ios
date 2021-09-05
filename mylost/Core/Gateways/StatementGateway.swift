//
//  StatementGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import Foundation

typealias StatementListCompletion =  (Result<StatementsListResponse, Error>) -> Void
typealias StatementCompletion =  (Result<[Statement], Error>) -> Void
typealias StatementListResponseType = (Result<StatementsListResponse, Error>)

protocol StatementGateway {
    func getStatementList(completion:  @escaping StatementCompletion)
}

class StatementGatewayImpl: StatementGateway{
    private let service = Service()
    
    func getStatementList(completion: @escaping StatementCompletion) {
        service.get(serviceMethod: .statementList) {(result: StatementListResponseType) in
            
            switch result {
            case .success(_):
                let newRes = result.flatMap { (resp) -> Result<[Statement], Error> in
                  .success(resp.getStatement())
                }
                completion(newRes)
                
            case .failure(let error):
                let newRes = result.flatMap { _ -> Result<[Statement], Error> in
                    .failure(error)
                }
                completion(newRes)
            }
        }
    }
    
}