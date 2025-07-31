//
//  KakaoLoginService.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/24/25.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

// MARK: - KakaoLoginResult
struct KakaoLoginResult {
    let accessToken: String
    let expiredAt: Date
    let refreshToken: String
    let refreshTokenExpiredAt: Date
}

// MARK: - KakaoLoginServiceProtocol
protocol KakaoLoginService {
    func signIn() async throws -> KakaoLoginResult
    func signOut() async throws
}

// MARK: - KakaoLoginService
final class KakaoLoginServiceImpl: KakaoLoginService {
    static let shared = KakaoLoginServiceImpl()
    
    private init() {}
    
    /// 카카오 로그인을 수행합니다. (카카오톡 -> 카카오계정 순서로 자동 선택)
    func signIn() async throws -> KakaoLoginResult {
        print("🟡 카카오 로그인 시작...")
        
        // 내부에서 최적의 로그인 방법을 자동 선택
        if UserApi.isKakaoTalkLoginAvailable() {
            print("📱 카카오톡 로그인 사용 가능 - 카카오톡으로 로그인 시도")
            return try await signInWithKakaoTalk()
        } else {
            print("🌐 카카오톡 로그인 불가능 - 카카오계정으로 로그인 시도")
            return try await signInWithKakaoAccount()
        }
    }
    
    func signOut() async throws {
        print("🟡 카카오 로그아웃 시작...")
        
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    print("🚫 카카오 로그아웃 실패: \(error)")
                    continuation.resume(throwing: KakaoLoginError.logoutFailed(error))
                } else {
                    print("✅ 카카오 로그아웃 성공")
                    continuation.resume(returning: ())
                }
            }
        }
    }
}

// MARK: - Private Methods
private extension KakaoLoginServiceImpl {
    /// 카카오톡 앱으로 로그인
    func signInWithKakaoTalk() async throws -> KakaoLoginResult {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                if let error = error {
                    print("🚫 카카오톡 로그인 실패: \(error)")
                    continuation.resume(throwing: KakaoLoginError.loginFailed(error))
                } else if let token = oAuthToken {
                    print("✅ 카카오톡 로그인 성공")
                    let result = KakaoLoginResult(
                        accessToken: token.accessToken,
                        expiredAt: token.expiredAt,
                        refreshToken: token.refreshToken,
                        refreshTokenExpiredAt: token.refreshTokenExpiredAt
                    )
                    continuation.resume(returning: result)
                } else {
                    print("🚫 카카오톡 로그인 - 알 수 없는 오류")
                    continuation.resume(throwing: KakaoLoginError.unknownError)
                }
            }
        }
    }
    
    /// 카카오계정으로 로그인 (웹뷰)
    func signInWithKakaoAccount() async throws -> KakaoLoginResult {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
                if let error = error {
                    print("🚫 카카오계정 로그인 실패: \(error)")
                    continuation.resume(throwing: KakaoLoginError.loginFailed(error))
                } else if let token = oAuthToken {
                    print("✅ 카카오계정 로그인 성공")
                    let result = KakaoLoginResult(
                        accessToken: token.accessToken,
                        expiredAt: token.expiredAt,
                        refreshToken: token.refreshToken,
                        refreshTokenExpiredAt: token.refreshTokenExpiredAt
                    )
                    continuation.resume(returning: result)
                } else {
                    print("🚫 카카오계정 로그인 - 알 수 없는 오류")
                    continuation.resume(throwing: KakaoLoginError.unknownError)
                }
            }
        }
    }
}

// MARK: - KakaoLoginError
enum KakaoLoginError: Error, LocalizedError {
    case loginFailed(Error)
    case logoutFailed(Error)
    case unknownError
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .loginFailed(let error):
            return "카카오 로그인 실패: \(error.localizedDescription)"
        case .logoutFailed(let error):
            return "카카오 로그아웃 실패: \(error.localizedDescription)"
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다"
        case .cancelled:
            return "사용자가 로그인을 취소했습니다"
        }
    }
}
