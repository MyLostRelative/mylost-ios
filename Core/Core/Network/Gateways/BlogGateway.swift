//
//  BlogGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Foundation

public typealias BlogListCompletion =  (Result<BlogListResponse, Error>) -> Void
public typealias BlogCompletion =  (Result<[Blog], Error>) -> Void
public typealias BlogListResponseType = (Result<BlogListResponse, Error>)

public protocol BlogGateway {
    func getBlogList(completion:  @escaping BlogCompletion)
}

public class BlogGatewayImpl: BlogGateway{
    private let service = Service()
    public init() {}
    public func getBlogList(completion: @escaping BlogCompletion) {
        service.get(serviceMethod: .blogList) {(result: BlogListResponseType) in
            
            switch result {
            case .success(_):
                let newRes = result.flatMap { (resp) -> Result<[Blog], Error> in
                  .success(resp.getBlog())
                }
                completion(newRes)
                
            case .failure(let error):
                let newRes = result.flatMap { _ -> Result<[Blog], Error> in
                    .failure(error)
                }
                completion(newRes)
            }
        }
    }
    
}
