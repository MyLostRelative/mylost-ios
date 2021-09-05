//
//  LoginGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation
import Swinject

typealias LoginGatewayCompletion =  (Result<LoginResponse, Error>) -> Void

protocol LoginGateway {
    func postLogin(params: [String: Any], completion:  @escaping LoginGatewayCompletion)
}

class LoginGatewayImpl: LoginGateway{
    private let service = Service()
    
    func postLogin(params: [String: Any], completion: @escaping LoginGatewayCompletion) {
        
        service.post(serviceMethod: .login, parameters: params) { (result: Result<LoginResponse, Error>)  in
            
            switch result {
            case .success(_):
                let newRes = result.flatMap { (resp) -> Result<LoginResponse, Error> in
                  .success(resp)
                }
                completion(newRes)
                
            case .failure(let error):
                let newRes = result.flatMap { _ -> Result<LoginResponse, Error> in
                    .failure(error)
                }
                completion(newRes)
            }
        }
    }
    
}


class LoginNetworkAssembly: NetworkAssembly {
    func assemble(container: Container) {
        container.register(LoginGatewayImpl.self) { resolver in
            LoginGatewayImpl.init()
        }
    }
    
    
}
