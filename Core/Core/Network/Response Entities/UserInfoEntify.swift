//
//  UserInfoEntify.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

public struct UserInfoResultResponse: Codable{
    let result: UserInfoResponse?
}

public struct UserInfoResponse: Codable{
    let id: Int?
    let username: String?
    let lastName: String?
    let firstName: String?
    let email: String?
    let mobileNumber: String?
}

public struct UserInfo{
    public let id: Int
    public let username: String
    public let lastName: String
    public let firstName: String
    public let email: String?
    public let mobileNumber: String?
}

extension UserInfoResultResponse {
    public func getUserInfo() -> UserInfo? {
        guard let response = result else {return nil}
        
            guard let id = response.id,
                  let username = response.username,
                  let lastName = response.lastName,
                  let firstName = response.firstName  else {return nil}
            return UserInfo(id: id,
                            username: username,
                            lastName: lastName,
                            firstName: firstName,
                            email: response.email,
                            mobileNumber: response.mobileNumber)
    }
}
