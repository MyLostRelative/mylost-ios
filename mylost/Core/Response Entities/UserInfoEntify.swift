//
//  UserInfoEntify.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

struct UserInfoResultResponse: Codable{
    let result: UserInfoResponse?
}

struct UserInfoResponse: Codable{
    let id: Int?
    let username: String?
    let lastName: String?
    let firstName: String?
    let email: String?
    let mobileNumber: String?
}

struct UserInfo{
    let id: Int
    let username: String
    let lastName: String
    let firstName: String
    let email: String?
    let mobileNumber: String?
}

extension UserInfoResultResponse {
    func getUserInfo() -> UserInfo? {
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
