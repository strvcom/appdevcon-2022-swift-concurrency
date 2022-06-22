//
//  LoginResponse.swift
//  Facematch
//
//  Created by Abel Osorio on 3/8/21.
//

import Foundation

struct LoginResponse: Decodable {
    let user: User
    let accessToken: String
}
