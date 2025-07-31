//
//  AppleLoginService.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/23/25.
//

import UIKit
import AuthenticationServices

// MARK: - AppleLoginResult
struct AppleLoginResult {
    let userIdentifier: String
    let fullName: PersonNameComponents?
    let email: String?
    let identityToken: String?
    let authorizationCode: String?
}

// MARK: - AppleLoginServiceProtocol
protocol AppleLoginService {
    func signInWithApple() async throws -> AppleLoginResult
    func signOut() async throws
}

// MARK: - AppleLoginService
final class AppleLoginServiceImpl: NSObject, AppleLoginService {
    static let shared = AppleLoginServiceImpl()
    
    private var continuation: CheckedContinuation<AppleLoginResult, Error>?
    
    private override init() {}
    
    func signInWithApple() async throws -> AppleLoginResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            performAppleLogin()
        }
    }
    
    func signOut() async throws {
        print("🍎 Apple 로그아웃 시작...")
        
        //TODO: 서버로 로그아웃 요청
        
        print("✅ Apple 로그아웃 완료 (클라이언트 사이드)")
    }
    
    private func performAppleLogin() {
        print("🍎 Apple 로그인 시작...")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        print("🍎 Request 생성 완료")
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        print("🍎 Controller 설정 완료, performRequests 호출...")
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleLoginServiceImpl: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleLoginError.invalidCredential)
            continuation = nil
            return
        }
        
        let identityTokenString = appleIDCredential.identityToken
            .flatMap { String(data: $0, encoding: .utf8) }
        
        let authorizationCodeString = appleIDCredential.authorizationCode
            .flatMap { String(data: $0, encoding: .utf8) }
        
        let result = AppleLoginResult(
            userIdentifier: appleIDCredential.user,
            fullName: appleIDCredential.fullName,
            email: appleIDCredential.email,
            identityToken: identityTokenString,
            authorizationCode: authorizationCodeString
        )
        
        continuation?.resume(returning: result)
        continuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleLoginServiceImpl: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // 현재 활성 window 자동 탐지
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            print("🍎 Presentation window: \(window)")
            return window
        }
        print("Window를 찾을 수 없습니다!")
        // iOS 13 이하 fallback
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIApplication.shared.windows.first!
    }
}

// MARK: - AppleLoginError
enum AppleLoginError: Error, LocalizedError {
    case invalidCredential
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid Apple ID credential"
        case .cancelled:
            return "Apple login was cancelled"
        }
    }
}
