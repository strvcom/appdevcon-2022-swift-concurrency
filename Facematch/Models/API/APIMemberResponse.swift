//
//  APIMemberResponse.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

struct APIMemberResponse {
    let members: [APIMember]

    enum CodingKeys: String, CodingKey {
        case members
    }

    init(from decoder: Decoder) throws {
        var members = [APIMember]()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        var membersContainer = try values.nestedUnkeyedContainer(forKey: .members)

        while !membersContainer.isAtEnd {
            let nestedDecoder = try membersContainer.superDecoder()

            do {
                let member = try APIMember(from: nestedDecoder)

                members.append(member)
            } catch is APIMember.ExpectedDecodingError {
                continue
            }
        }

        self.members = members
    }
}

extension APIMemberResponse: Decodable {}
