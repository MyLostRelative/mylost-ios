//
//  UserInfoBearerGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import Swinject

typealias UserInfoBearerResultCompletion =  (Result<UserInfoResultResponse, Error>) -> Void
typealias UserInfoBearerResultResponseType = (Result<UserInfoResultResponse, Error>)

protocol UserInfoBearerGateway {
    func getUser(bearerToken: String, completion:  @escaping UserInfoBearerResultCompletion)
}

class UserInfoBearerGatewayImpl: UserInfoBearerGateway{
    
    private let service = Service()
    
    func getUser(bearerToken: String, completion: @escaping UserInfoBearerResultCompletion) {
        service.get(tokenType: .bearer(token: bearerToken) ,
                    serviceMethod: .profile) {(result: UserInfoBearerResultResponseType) in
            
            switch result {
            case .success(_):
                let newRes = result.flatMap { (resp) -> Result<UserInfoResultResponse, Error> in
                  .success(resp)
                }
                completion(newRes)
                
            case .failure(let error):
                let newRes = result.flatMap { _ -> Result<UserInfoResultResponse, Error> in
                    .failure(error)
                }
                completion(newRes)
            }
        }
    }
    
}

class UserInfoBearerNetworkAssembly: NetworkAssembly {
    func assemble(container: Container) {
        container.register(UserInfoBearerGatewayImpl.self) { resolver in
            UserInfoBearerGatewayImpl()
        }
    }
}
