//
//  LoginGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation
import Swinject

public typealias LoginGatewayCompletion =  (Result<LoginResponse, Error>) -> Void

public protocol LoginGateway {
    func postLogin(params: [String: Any], completion:  @escaping LoginGatewayCompletion)
}

public class LoginGatewayImpl: LoginGateway{
    private let service = Service()
    public init() {}
    public func postLogin(params: [String: Any], completion: @escaping LoginGatewayCompletion) {
        
        service.post(serviceMethod: .loginToken, parameters: params) { (result: Result<LoginResponse, Error>)  in
            
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
    
    public func postLoginToken(params: [String: Any], completion: @escaping LoginGatewayCompletion) {
        
        service.post(serviceMethod: .loginToken, parameters: params) { (result: Result<LoginResponse, Error>)  in
            
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


public class LoginNetworkAssembly: NetworkAssembly {
    public init() {}
    public func assemble(container: Container) {
        container.register(LoginGatewayImpl.self) { resolver in
            LoginGatewayImpl.init()
        }
    }
    
    
}
