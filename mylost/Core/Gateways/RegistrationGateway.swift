//
//  RegistrationGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation
import Swinject

typealias RegistrationGatewayCompletion =  (Result<RegistrationResponse, Error>) -> Void

protocol RegistrationGateway {
    func postRegistration(params: [String: Any], completion:  @escaping RegistrationGatewayCompletion)
}

class RegistrationGatewayImpl: RegistrationGateway {
    private let service = Service()
    
    func postRegistration(params: [String: Any], completion: @escaping RegistrationGatewayCompletion) {
        
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

class RegistrationNetworkAssembly: NetworkAssembly {
    func assemble(container: Container) {
        container.register(RegistrationGatewayImpl.self) { _ in
            RegistrationGatewayImpl()
        }
    }
}
