//
//  CoreAuthKit.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/21/25.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

import AuthenticationServices

// MARK: - CoreAuthKit Implementation
public final class CoreAuthKit: AuthenticationService {
    // MARK: - Shared Instance
    public static let shared = CoreAuthKit()
    
    // MARK: - Private Properties
    private let tokenManager: MoodieAuthTokenHandleable
    private let appleLoginService: AppleLoginService
    private let kakaoLoginService: KakaoLoginServiceImpl
    
    // MARK: - Initialization
    private init() {
        self.tokenManager = MoodieAuthTokenManager()
        self.appleLoginService = AppleLoginServiceImpl.shared
        self.kakaoLoginService = KakaoLoginServiceImpl.shared
        
        KakaoSDK.initSDK(appKey: "c6e355b541377b0886d546a44fc76f50")
    }
    
    // 테스트용 커스텀 초기화
    init(tokenManager: MoodieAuthTokenHandleable) {
        self.tokenManager = tokenManager
        self.appleLoginService = AppleLoginServiceImpl.shared
        self.kakaoLoginService = KakaoLoginServiceImpl.shared
    }
}

// MARK: - User Action Methods (비즈니스 로직 포함)
extension CoreAuthKit {
    /// 카카오 로그인 프로세스를 수행합니다.
    public func performKakaoLogin() async -> MoodieAuthenticationResultType {
        print("🚀 카카오 로그인 프로세스 시작 🚀")
        
        do {
            // 1. 카카오 로그인
            let kakaoResult = try await kakaoLoginService.signIn()
            
            //TODO: 서버로 카카오 유저의 정보를 넘겨주고, 엑세스 토큰/리프레시 토큰을 받아와 키체인에 저장해야한다.
            
            // 2. 토큰 정보 저장
            tokenManager.saveTokens(
                loginType: .kakao,
                accessToken: kakaoResult.accessToken,
                expiredAt: kakaoResult.expiredAt,
                refreshToken: kakaoResult.refreshToken,
                refreshTokenExpiredAt: kakaoResult.refreshTokenExpiredAt
            )
            
            // 3. 성공 결과 반환
            print("✅ 카카오 로그인 성공 ✅")
            let successInfo = AuthSuccessInfo(
                loginType: .kakao,
                message: LoginType.kakao.loginSuccessDescription
            )
            return .success(successInfo)
            
        } catch {
            print("🚫 카카오 로그인 실패 🚫 \n Error Detail: \(error)")
            return .failure(.kakaoLoginFailed(error))
        }
    }
    
    public func performAppleLogin() async throws -> MoodieAuthenticationResultType {
        print("🚀 애플 로그인 프로세스 시작")
        
        do {
            let appleUserInfo = try await appleLoginService.signInWithApple()
            
            //TODO: 서버로 애플 유저의 정보를 넘겨주고, 엑세스 토큰/리프레시 토큰을 받아와 키체인에 저장해야한다.
            
            return .success(
                AuthSuccessInfo(
                    loginType: .apple,
                    message: LoginType.apple.loginSuccessDescription
                )
            )
        } catch {
            print("🚫 애플 로그인 실패 🚫 \n Error Detail: \(error)")
            return .failure(.appleLoginFailed(error))
        }
    }
    
    /// 로그아웃 시 전체 로그아웃 프로세스를 수행합니다.
    public func performLogout() async throws -> MoodieAuthenticationResultType {
        print("🚪 로그아웃 프로세스 시작")
        
        let loginType = tokenManager.retrieveLoginType()
        
        switch loginType {
        case .kakao:
            do {
                try await kakaoLoginService.signOut()
                
                tokenManager.clearAllTokens()
                
                return .success(
                    AuthSuccessInfo(
                        loginType: .kakao,
                        message: loginType.logoutSuccessDescription
                    )
                )
            } catch {
                print("🚫 카카오 로그아웃 실패: \(error)")
                return .failure(.kakaoLogoutFailed(error))
            }
        case .apple:
            do {
                try await appleLoginService.signOut()
                //TODO: tokenManaer.clearAllTokens
                
                return .success(
                    AuthSuccessInfo(
                        loginType: .apple,
                        message: loginType.logoutSuccessDescription
                    )
                )
            } catch {
                print("🚫 애플 로그아웃 실패: \(error)")
                return .failure(.appleLogoutFailed(error))
            }
        }
    }
    
    /// 토큰 갱신 시 전체 갱신 프로세스를 수행합니다.
    public func performTokenRefresh() {
        print("🔄 토큰 갱신 프로세스 시작")
        
        print("✅ 토큰 갱신 프로세스 완료")
    }
}

// MARK: - Query Methods (순수함수, 조회 전용)
extension CoreAuthKit {
    /// 현재 유효한 액세스 토큰을 반환합니다.
    public func retrieveAccessToken() -> String? {
        return tokenManager.retrieveAccessToken()
    }
    
    /// 로그인 상태를 확인합니다.
    public func isLoggedIn() -> Bool {
        return tokenManager.isLoggedIn()
    }
    
    /// 토큰 만료 여부를 확인합니다.
    public func isTokenExpired() -> Bool {
        return tokenManager.isTokenExpired()
    }
}
