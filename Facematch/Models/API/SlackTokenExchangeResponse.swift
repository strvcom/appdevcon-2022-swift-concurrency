//
//  SlackTokenExchangeResponse.swift
//  Facematch
//
//  Created by Jan Kaltoun on 11.08.2020.
//

import Foundation

struct SlackTokenExchangeResponse {
    var userId: String
    var accessToken: String
}

extension SlackTokenExchangeResponse: Decodable {}
