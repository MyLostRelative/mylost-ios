//
//  BlogGateway.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Foundation

typealias BlogListCompletion =  (Result<BlogListResponse, Error>) -> Void
typealias BlogCompletion =  (Result<[Blog], Error>) -> Void
typealias BlogListResponseType = (Result<BlogListResponse, Error>)

protocol BlogGateway {
    func getBlogList(completion:  @escaping BlogCompletion)
}

class BlogGatewayImpl: BlogGateway{
    private let service = Service()
    
    func getBlogList(completion: @escaping BlogCompletion) {
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
