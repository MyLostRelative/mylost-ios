//
//  GuestUserIfo.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import Foundation

public struct GuestUserInfoResultResponse: Codable{
    let result: UserInfoResponse?
}

public struct GuestUserInfoResponse: Codable{
    let firstName: String?
    let email: String?
    let mobileNumber: String?
}

public struct GuestUserInfo{
    public let firstName: String
    public let email: String
    public let mobileNumber: String
}

extension GuestUserInfoResultResponse {
    public func getGuestUserInfo() -> GuestUserInfo? {
        guard let response = result else {return nil}
        
            guard  let firstName = response.firstName,
                   let email = response.email,
                   let mobileNumber = response.mobileNumber else {return nil}
            return GuestUserInfo(  firstName: firstName,
                            email: email,
                            mobileNumber: mobileNumber)
    }
}
