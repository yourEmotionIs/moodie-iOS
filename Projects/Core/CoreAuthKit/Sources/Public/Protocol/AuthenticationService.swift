//
//  AuthenticationService.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/21/25.
//

import Foundation

public protocol AuthenticationService {
    /// 카카오 로그인 성공 시 전체 로그인 프로세스를 수행합니다.
    /// - Returns: 로그인 결과
    /// - Throws: 로그인 실패 시 에러
    func performKakaoLogin() async throws -> MoodieAuthenticationResultType
    
    /// 애플 로그인 성공 시 전체 로그인 프로세스를 수행합니다.
    /// - Returns: 로그인 결과
    /// - Throws: 로그인 실패 시 에러
    func performAppleLogin() async throws -> MoodieAuthenticationResultType
    
    /// 로그아웃 시 전체 로그아웃 프로세스를 수행합니다.
    /// - Returns: 로그아웃 결과
    /// - Throws: 로그아웃 실패 시 에러
    func performLogout() async throws -> MoodieAuthenticationResultType
    
    /// 토큰 갱신 시 전체 갱신 프로세스를 수행합니다.
    func performTokenRefresh()
    
    // MARK: - 조회용 함수 (순수함수, 부작용 없음)
    
    /// 현재 유효한 액세스 토큰을 반환합니다.
    /// - Returns: 유효한 액세스 토큰 (없으면 nil)
    func retrieveAccessToken() -> String? // 🔧 오타 수정: retriveAccessToken -> retrieveAccessToken
    
    /// 로그인 상태를 확인합니다.
    /// - Returns: 로그인 여부
    func isLoggedIn() -> Bool
    
    /// 토큰 만료 여부를 확인합니다.
    /// - Returns: 만료 여부
    func isTokenExpired() -> Bool
}
