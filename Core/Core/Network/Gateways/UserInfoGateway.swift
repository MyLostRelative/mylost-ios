//
//  UserInfoGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Swinject

public typealias UserInfoResultCompletion =  (Result<GuestUserInfoResultResponse, Error>) -> Void
public typealias UserInfoResultResponseType = (Result<GuestUserInfoResultResponse, Error>)

public protocol UserInfoGateway {
    func getUser(userID: Int, completion:  @escaping UserInfoResultCompletion)
}

public class UserInfoGatewayImpl: UserInfoGateway{
    private let service = Service()
    
    public init() {}
    
    public func getUser(userID: Int, completion: @escaping UserInfoResultCompletion) {
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

public class UserInfoetworkAssembly: NetworkAssembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(UserInfoGatewayImpl.self) { resolver in
            UserInfoGatewayImpl()
        }
    }
}
