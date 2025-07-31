//
//  MoodieAuthToken.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/21/25.
//

import Foundation

struct MoodieAuthToken: Codable {
    let loginType: LoginType
    
    let accessToken: String
    let expiredAt: Date
    let refreshToken: String
    let refreshTokenExpiredAt: Date
    
    enum CodingKeys: String, CodingKey {
        case loginType
        
        case accessToken
        case expiredAt
        case refreshToken
        case refreshTokenExpiredAt
    }
    
    init(
        loginType: LoginType,
        accessToken: String,
        expiredAt: Date,
        refreshToken: String,
        refreshTokenExpiredAt: Date
    ) {
        self.loginType = loginType
        self.accessToken = accessToken
        self.expiredAt = expiredAt
        self.refreshToken = refreshToken
        self.refreshTokenExpiredAt = refreshTokenExpiredAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let loginTypeRawValue = try container.decode(String.self, forKey: .loginType)
        
        guard let loginType = LoginType(rawValue: loginTypeRawValue) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid login type: \(loginTypeRawValue)"
                )
            )
        }
        
        self.loginType = loginType
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.expiredAt = try container.decode(Date.self, forKey: .expiredAt)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        self.refreshTokenExpiredAt = try container.decode(Date.self, forKey: .refreshTokenExpiredAt)
        
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(loginType.rawValue, forKey: .loginType)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(expiredAt, forKey: .expiredAt)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(refreshTokenExpiredAt, forKey: .refreshTokenExpiredAt)
    }
}
