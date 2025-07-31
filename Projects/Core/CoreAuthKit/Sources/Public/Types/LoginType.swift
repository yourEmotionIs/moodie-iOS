//
//  LoginType.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/26/25.
//

import Foundation

public enum LoginType: String, CaseIterable, Codable {
    case kakao
    case apple
    
    var loginSuccessDescription: String {
        switch self {
        case .kakao:
            return "카카오 로그인이 성공적으로 완료되었습니다."
        case .apple:
            return "애플 로그인이 성공적으로 완료되었습니다."
        }
    }
    
    var logoutSuccessDescription: String {
        switch self {
        case .kakao:
            return "카카오 로그아웃이 성공적으로 완료되었습니다."
        case .apple:
            return "애플 로그아웃이 성공적으로 완료되었습니다."
        }
    }
}
