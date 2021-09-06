//
//  UserInfoGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Swinject

typealias UserInfoResultCompletion =  (Result<GuestUserInfoResultResponse, Error>) -> Void
typealias UserInfoResultResponseType = (Result<GuestUserInfoResultResponse, Error>)

protocol UserInfoGateway {
    func getUser(userID: Int, completion:  @escaping UserInfoResultCompletion)
}

class UserInfoGatewayImpl: UserInfoGateway{
    private let service = Service()
    
    func getUser(userID: Int, completion: @escaping UserInfoResultCompletion) {
        service.get(serviceMethod: .userInfo(userID: userID)) {(result: UserInfoResultResponseType) in
            
            switch result {
            case .success(_):
                let newRes = result.flatMap { (resp) -> Result<GuestUserInfoResultResponse, Error> in
                  .success(resp)
                }
                completion(newRes)
                
            case .failure(let error):
                let newRes = result.flatMap { _ -> Result<GuestUserInfoResultResponse, Error> in
                    .failure(error)
                }
                completion(newRes)
            }
        }
    }
    
}

class UserInfoetworkAssembly: NetworkAssembly {
    func assemble(container: Container) {
        container.register(UserInfoGatewayImpl.self) { resolver in
            UserInfoGatewayImpl()
        }
    }
}
