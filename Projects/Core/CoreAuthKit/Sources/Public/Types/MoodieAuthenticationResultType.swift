//
//  MoodieAuthenticationResult.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/24/25.
//

import Foundation

// MARK: - AuthResult
public enum MoodieAuthenticationResultType {
    case success(AuthSuccessInfo)
    case failure(AuthError)
}

// MARK: - AuthSuccessInfo
public struct AuthSuccessInfo {
    public let loginType: LoginType
    public let message: String
    
    public init(loginType: LoginType, message: String) {
        self.loginType = loginType
        self.message = message
    }
}

// MARK: - AuthError
public enum AuthError: Error, LocalizedError {
    case kakaoLoginFailed(Error)
    case kakaoLogoutFailed(Error)
    case appleLoginFailed(Error)
    case appleLogoutFailed(Error)
    case tokenSaveFailed
    case networkError
    case cancelled
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .kakaoLoginFailed(let error):
            return "카카오 로그인 실패: \(error.localizedDescription)"
        case .kakaoLogoutFailed(let error):
            return "카카오 로그아웃 실패: \(error.localizedDescription)"
        case .appleLoginFailed(let error):
            return "애플 로그인 실패: \(error.localizedDescription)"
        case .appleLogoutFailed(let error):
            return "애플 로그아웃 실패: \(error.localizedDescription)"
        case .tokenSaveFailed:
            return "토큰 저장 실패"
        case .networkError:
            return "네트워크 연결 오류"
        case .cancelled:
            return "사용자가 로그인을 취소했습니다"
        case .unknown(let error):
            return "알 수 없는 오류: \(error.localizedDescription)"
        }
    }
}
