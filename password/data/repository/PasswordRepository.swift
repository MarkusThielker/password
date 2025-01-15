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

protocol PasswordRepository {
    func getAllPasswords() -> [Password]
    func getPassword(withID id: UUID) -> Password?
    func savePassword(_ password: Password) throws
    func deletePassword(withID id: UUID) throws
}

class KeychainPasswordRepository: PasswordRepository {
    
    private let serviceName = "dev.thielker.password"

    func getAllPasswords() -> [Password] {
        
        // TODO: fix query to work with 'kSecMatchLimit as String: kSecMatchLimitAll'
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecMatchLimit as String: 100,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status != errSecSuccess {
            print("Error retrieving passwords: \(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString)")
            return []
        }

        guard let items = result as? [[String: Any]] else {
            print("No passwords found.")
            return []
        }
        
        var passwords: [Password] = []
        for item in items {
            if let data = item[kSecValueData as String] as? Data,
               let password = try? JSONDecoder().decode(Password.self, from: data) {
                passwords.append(password)
            }
        }
        return passwords
    }
    
    func getPassword(withID id: UUID) -> Password? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: id.uuidString,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        guard let data = result as? Data,
              let password = try? JSONDecoder().decode(Password.self, from: data) else {
            return nil
        }
        
        return password
    }
    
    func savePassword(_ password: Password) throws {

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
