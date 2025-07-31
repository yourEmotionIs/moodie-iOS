//
//  MoodieAuthtokenManager.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/21/25.
//

// MoodieAuthTokenManager.swift - KeychainAccessible 프로토콜 사용
import Foundation
import Security

internal final class MoodieAuthTokenManager: MoodieAuthTokenHandleable, KeychainAccessible {
    
    // MARK: - Constants
    private enum KeychainKey {
        static let authToken = "MoodieAuthToken"
    }
    
    // MARK: - AuthTokenHandleable Implementation
    
    func saveTokens(
        loginType: LoginType,
        accessToken: String,
        expiredAt: Date,
        refreshToken: String,
        refreshTokenExpiredAt: Date
    ) {
        print("📝 키체인에 토큰 저장 시작...")
        
        do {
            let authToken = MoodieAuthToken(
                loginType: loginType,
                accessToken: accessToken,
                expiredAt: expiredAt,
                refreshToken: refreshToken,
                refreshTokenExpiredAt: refreshTokenExpiredAt
            )
            
            let tokenData = try encodeAuthToken(authToken)
            
            try saveToKeychain(data: tokenData, key: KeychainKey.authToken)
            
            print("✅ 토큰 저장 성공: \(loginType.rawValue)")
            
        } catch {
            print("🚫 토큰 저장 실패: \(error)")
        }
    }
    
    func retrieveAccessToken() -> String {
        print("🔍 키체인에서 현재 액세스 토큰 조회")
        
        guard let authToken = loadAuthTokenFromKeychain() else {
            print("🚫 저장된 토큰이 없습니다")
            return ""
        }
        
        return authToken.accessToken
    }
    
    func retrieveRefreshToken() -> String {
        print("🔍 키체인에서 리프레시 토큰 조회")
        
        guard let authToken = loadAuthTokenFromKeychain() else {
            print("🚫 저장된 토큰이 없습니다")
            return ""
        }
        
        return authToken.refreshToken
    }
    
    func retrieveLoginType() -> LoginType {
        print("🔍 키체인에서 로그인 타입 조회")
        
        guard let authToken = loadAuthTokenFromKeychain() else {
            print("🚫 저장된 토큰이 없습니다. 기본값 .kakao 반환")
            return .kakao
        }
        
        return authToken.loginType
    }
    
    func isLoggedIn() -> Bool {
        print("🔍 키체인에서 로그인 상태 확인")
        return loadAuthTokenFromKeychain() != nil
    }
    
    func isTokenExpired() -> Bool {
        print("🔍 키체인에서 토큰 만료 여부 확인")
        
        guard let authToken = loadAuthTokenFromKeychain() else {
            print("🚫 저장된 토큰이 없습니다")
            return true
        }
        
        let isExpired = authToken.expiredAt <= Date()
        print(isExpired ? "⏰ 토큰이 만료되었습니다" : "✅ 토큰이 유효합니다")
        
        return isExpired
    }
    
    func deleteAuthToken() {
        print("🗑️ 키체인에서 Auth 토큰 삭제")
        
        do {
            try deleteFromKeychain(key: KeychainKey.authToken)
            print("✅ 토큰 삭제 완료")
        } catch {
            print("🚫 토큰 삭제 실패: \(error)")
        }
    }
    
    func clearAllTokens() {
        print("🗑️ 키체인에서 모든 토큰 삭제")
        
        do {
            try clearAllKeychainItems()
            print("✅ 토큰 삭제 완료")
        } catch {
            print("🚫 토큰 삭제 실패: \(error)")
        }
    }
}

// MARK: - Private Helper Methods
private extension MoodieAuthTokenManager {
    /// MoodieAuthToken을 JSON으로 인코딩
    func encodeAuthToken(_ authToken: MoodieAuthToken) throws -> Data {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try encoder.encode(authToken)
        } catch {
            throw KeychainError.encodingFailed(error)
        }
    }
    
    /// 키체인에서 MoodieAuthToken 로드
    func loadAuthTokenFromKeychain() -> MoodieAuthToken? {
        do {
            guard let tokenData = try loadFromKeychain(key: KeychainKey.authToken) else {
                return nil
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(MoodieAuthToken.self, from: tokenData)
            
        } catch {
            print("🚫 토큰 로드/디코딩 실패: \(error)")
            return nil
        }
    }
}
