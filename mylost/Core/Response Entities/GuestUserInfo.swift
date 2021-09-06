//
//  GuestUserIfo.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import Foundation

struct GuestUserInfoResultResponse: Codable{
    let result: UserInfoResponse?
}

struct GuestUserInfoResponse: Codable{
    let firstName: String?
    let email: String?
    let mobileNumber: String?
}

struct GuestUserInfo{
    let firstName: String
    let email: String
    let mobileNumber: String
}

extension GuestUserInfoResultResponse {
    func getGuestUserInfo() -> GuestUserInfo? {
        guard let response = result else {return nil}
        
            guard  let firstName = response.firstName,
                   let email = response.email,
                   let mobileNumber = response.mobileNumber else {return nil}
            return GuestUserInfo(  firstName: firstName,
                            email: email,
                            mobileNumber: mobileNumber)
    }
}
