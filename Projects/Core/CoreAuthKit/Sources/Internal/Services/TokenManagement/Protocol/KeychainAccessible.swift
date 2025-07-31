//
//  KeychainAccessible.swift
//  CoreAuthKit
//
//  Created by 이숭인 on 7/26/25.
//

import Foundation
import Security

protocol KeychainAccessible {
    var serviceName: String { get }
}

// MARK: - Default Implementation
extension KeychainAccessible {
    
    var serviceName: String {
        return "com.moodie.authkit"
    }
    
    /// 키체인에 데이터 저장
    func saveToKeychain(data: Data, key: String) throws {
        // 기존 아이템이 있다면 먼저 삭제
        try? deleteFromKeychain(key: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }
    
    /// 키체인에서 데이터 로드
    func loadFromKeychain(key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil // 아이템이 없는 것은 에러가 아님
            }
            throw KeychainError.loadFailed(status)
        }
        
        return result as? Data
    }
    
    /// 키체인에서 데이터 삭제
    func deleteFromKeychain(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
    
    /// 키체인에서 모든 아이템 삭제 (서비스별)
    func clearAllKeychainItems() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

// MARK: - Keychain Error
enum KeychainError: Error, LocalizedError {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
    case encodingFailed(Error)
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .saveFailed(let status):
            return "키체인 저장 실패: \(status)"
        case .loadFailed(let status):
            return "키체인 로드 실패: \(status)"
        case .deleteFailed(let status):
            return "키체인 삭제 실패: \(status)"
        case .encodingFailed(let error):
            return "인코딩 실패: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "디코딩 실패: \(error.localizedDescription)"
        }
    }
}
