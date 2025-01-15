//
//  ListViewModel.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import Foundation

class ListViewModel: ObservableObject {
    
    @Published var passwords: [Password] = []
    
    private let passwordRepository: PasswordRepository

    init(passwordRepository: PasswordRepository = KeychainPasswordRepository()) {
        self.passwordRepository = passwordRepository
        loadAllPasswords()
    }
    
    func loadAllPasswords() {
        passwords = passwordRepository.getAllPasswords()
    }
    
    func loadPassword(withID id: UUID) -> Password? {
        return passwordRepository.getPassword(withID: id)
    }
    
    func savePassword(name: String, value: String) {
        let newPassword = Password(name: name, value: value)

        do {

            try passwordRepository.savePassword(newPassword)
            print ("Saved password successfully")
            loadAllPasswords()

        } catch {
            print("Error saving password: \(error)")
            // TODO: display error to user
        }
    }
    
    func deletePassword(_ password: Password) {
        do {
            try passwordRepository.deletePassword(withID: password.id)
            loadAllPasswords()
        } catch {
            print("Error deleting password: \(error)")
            // TODO: display error to user
        }
    }
}
