//
//  StatementPostGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation
import Swinject

typealias StatementPostGatewayCompletion =  (Result<GeneralPostResponse, Error>) -> Void

protocol StatementPostGateway {
    func postStatementPost(params: [String: Any], completion:  @escaping StatementPostGatewayCompletion)
}

class StatementPostGatewayImpl: StatementPostGateway{
    private let service = Service()
    
    func postStatementPost(params: [String: Any], completion: @escaping StatementPostGatewayCompletion) {
        
        service.post(serviceMethod: .addPost, parameters: params) { (result: Result<GeneralPostResponse, Error>)  in
            
            switch result {
            case .success(_):
                let newRes = result.flatMap { (resp) -> Result<GeneralPostResponse, Error> in
                  .success(resp)
                }
                completion(newRes)
                
            case .failure(let error):
                let newRes = result.flatMap { _ -> Result<GeneralPostResponse, Error> in
                    .failure(error)
                }
                completion(newRes)
            }
        }
    }
    
}


class StatementPostAssembly: NetworkAssembly {
    func assemble(container: Container) {
        container.register(StatementPostGatewayImpl.self) { resolver in
            StatementPostGatewayImpl()
        }
    }
}
