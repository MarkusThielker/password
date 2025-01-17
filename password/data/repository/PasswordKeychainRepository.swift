//
//  PasswordRepository.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import Foundation
import Security

enum KeychainError: Error {
    case unknown
    case duplicateItem
    case itemNotFound
    case unexpectedPasswordData
}

class PasswordKeychainRepository {
    
    private let serviceName = "dev.thielker.password"
    
    func getPassword(withID id: UUID) -> PasswordKC? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: id.uuidString,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        guard let data = result as? Data,
              let password = try? JSONDecoder().decode(PasswordKC.self, from: data) else {
            return nil
        }
        
        return password
    }
    
    func createPassword(_ password: PasswordKC) throws {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Generic password item
            kSecAttrService as String: serviceName, // Service name for your app
            kSecAttrAccount as String: password.id.uuidString, // Unique identifier
            kSecValueData as String: try JSONEncoder().encode(password) // Encode password data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                throw KeychainError.duplicateItem
            } else {
                throw KeychainError.unknown
            }
        }
    }
    
    func deletePassword(withID id: UUID) throws {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: id.uuidString
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            } else {
                throw KeychainError.unknown
            }
        }
    }
}
