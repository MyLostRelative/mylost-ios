//
//  ServiceCall.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//


import UIKit


//This is main status for service call. If response is good it must be success , and it is generic. if not it would be error wuth it's type
//if internet connection is bad there is internetConnection case , and if service data not wrapped it has notHaveData.
enum Status <T>{
    case success(T)
    case fail(ErrorType)
}

enum ErrorType {
    case internetConnection
    case notHaveData
}

/**
**New API ADDing principes**
.if i want another api call than i must add this case in ServiceMethods.
 */
enum ServiceMethods {
    case statementList
}

extension ServiceMethods {
    func getURL() -> URL?{
        switch self {
        case .statementList:
            return URL(string: "https://run.mocky.io/v3/e9e1301c-fdd5-47ca-ba51-3fa7c51209ed")
       
        }
    }
}

class Service : NSObject{
  
    func get<T: Decodable>(serviceMethod: ServiceMethods , withCompletion completion: @escaping (Result<T, Error>) -> Void)  {
        guard let url = serviceMethod.getURL() else {
            completion(Result.failure(ErrorType.notHaveData as! Error))
            return
        }
        
        let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
             
                if error != nil || response == nil {
                    completion(Result.failure(error!))
                    return
                }
                guard let data = data else {
                    completion(Result.failure(error!))
                    return
                }
                
                let wrapper = try? JSONDecoder().decode(T.self
                                                        , from: data)
                if let wrapper = wrapper {
                    completion(Result.success(wrapper))
                }else{
                    completion(Result.failure(error!))
                }
                } )
            task.resume()
    }
}

extension Error {
    func getError(with type: ErrorType)-> String{
        switch type {
        case .internetConnection:
            return "Sorry you havent internet"
        case .notHaveData:
            return "No data"
        }
    }
}
