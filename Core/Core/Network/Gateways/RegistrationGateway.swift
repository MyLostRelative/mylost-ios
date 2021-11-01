//
//  RegistrationGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation
import Swinject

public typealias RegistrationGatewayCompletion =  (Result<RegistrationResponse, Error>) -> Void

public protocol RegistrationGateway {
    func postRegistration(params: [String: Any], completion:  @escaping RegistrationGatewayCompletion)
}

public class RegistrationGatewayImpl: RegistrationGateway {
    private let service = Service()
    public init() {}
    public func postRegistration(params: [String: Any], completion: @escaping RegistrationGatewayCompletion) {
        
        service.post(serviceMethod: .registration, parameters: params) { (result: Result<RegistrationResponse, Error>)  in
            
            switch result {
            case .success(_):
                let newRes = result.flatMap { (resp) -> Result<RegistrationResponse, Error> in
                  .success(resp)
                }
                completion(newRes)
                
            case .failure(let error):
                let newRes = result.flatMap { _ -> Result<RegistrationResponse, Error> in
                    .failure(error)
                }
                completion(newRes)
            }
        }
    }
    
}

public class RegistrationNetworkAssembly: NetworkAssembly {
    public init() {}
    public func assemble(container: Container) {
        container.register(RegistrationGatewayImpl.self) { _ in
            RegistrationGatewayImpl()
        }
    }
}
