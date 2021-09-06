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
    case statementList(statement: StatementSearchEntity)
    case blogList
    case login
    case loginToken
    case registration
    case addPost
    case profile
    case userInfo(userID: Int)
    case userPosts(userID: Int)
}

extension ServiceMethods {
    func getURL() -> URL?{
        switch self {
        case .statementList(let statement ):
            return URL(string: "https://mylost-api.herokuapp.com/ads?relationType=\(statement.relationType)&gender=\(statement.gender)&bloodType=\(statement.bloodType)&city=\(statement.city)&fromAge=\(statement.fromAge)&toAge=\(statement.toAge)&query=\(statement.query)")
        case .blogList:
            return URL(string: "https://mylost-api.herokuapp.com/blogs")
        case .login:
            return URL(string: "https://mylost-api.herokuapp.com/users/login")
        case .loginToken:
            return URL(string: "https://mylost-api.herokuapp.com/auth/login")
        case .profile:
            return URL(string: "https://mylost-api.herokuapp.com/profile")
        case .registration:
            return URL(string: "https://mylost-api.herokuapp.com/users/register")
        case .addPost:
            return URL(string: "https://mylost-api.herokuapp.com/ads")
        case .userInfo(let userID):
            return URL(string: "https://mylost-api.herokuapp.com/users/" + userID.description)
        case .userPosts(let userID):
            return URL(string: "https://mylost-api.herokuapp.com/ads/user/" + userID.description)
        }
    }
}

class Service : NSObject{
    enum TokenType {
        case normal
        case bearer(token: String)
    }
  
    func get<T: Decodable>(tokenType: TokenType = .normal,
                           serviceMethod: ServiceMethods , withCompletion completion: @escaping (Result<T, Error>) -> Void)  {
        guard let url = serviceMethod.getURL() else {
            completion(Result.failure(ErrorType.notHaveData as! Error))
            return
        }
        var request = URLRequest(url: url)

        switch tokenType {
        case .bearer(let token):
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        default:
            break
        }
        
        let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
             
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
                    guard let error = error else {
                        return completion(Result.failure(LocalError()))
                    }
                    completion(Result.failure(error))
                }
                } )
            task.resume()
    }
    
    func post<T: Decodable> (serviceMethod: ServiceMethods ,
                             parameters: [String: Any], withCompletion completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = serviceMethod.getURL() else {
            completion(Result.failure(ErrorType.notHaveData as! Error))
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
         
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
                guard let error = error else {
                    return completion(Result.failure(LocalError()))
                }
                completion(Result.failure(error))
            }
            } )
        task.resume()
    }
}

class LocalError: Error {
    
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

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
