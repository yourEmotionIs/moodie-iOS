//
//  AuthTokenHandleable.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/21/25.
//

import Foundation

protocol MoodieAuthTokenHandleable {
    func saveTokens(
        loginType: LoginType,
        accessToken: String,
        expiredAt: Date,
        refreshToken: String,
        refreshTokenExpiredAt: Date
    )
    func retrieveAccessToken() -> String
    func retrieveRefreshToken() -> String
    func retrieveLoginType() -> LoginType
    
    func isLoggedIn() -> Bool
    func isTokenExpired() -> Bool
    
    func deleteAuthToken()
    func clearAllTokens()
}
