//
//  StatementGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import Swinject

typealias StatementListCompletion =  (Result<StatementsListResponse, Error>) -> Void
typealias StatementCompletion =  (Result<[Statement], Error>) -> Void
typealias StatementListResponseType = (Result<StatementsListResponse, Error>)

protocol StatementGateway {
    func getStatementList(statement: StatementSearchEntity,completion:  @escaping StatementCompletion)
    func getStatementListByUser(userID: Int, completion: @escaping StatementCompletion)
}

class StatementGatewayImpl: StatementGateway{
    private let service = Service()
    
    func getStatementList(statement: StatementSearchEntity, completion: @escaping StatementCompletion) {
        service.get(serviceMethod: .statementList(statement: statement)) {(result: StatementListResponseType) in
            
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
    
    func getStatementListByUser(userID: Int, completion: @escaping StatementCompletion) {
        service.get(serviceMethod: .userPosts(userID: userID)) {(result: StatementListResponseType) in
            
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

class StatementNetworkAssembly: NetworkAssembly {
    func assemble(container: Container) {
        container.register(StatementGatewayImpl.self) { resolver in
            StatementGatewayImpl()
        }
    }
}
