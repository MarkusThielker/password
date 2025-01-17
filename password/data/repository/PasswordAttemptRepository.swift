//
//  PasswordAttemptRepository.swift
//  password
//
//  Created by Markus Thielker on 17.01.25.
//

import Foundation
import SwiftUICore
import SwiftData

class PasswordAttemptRepository {
    
    private let context: ModelContext
    
    init(_ context: ModelContext) {
        self.context = context
    }
    
    func getPasswordAttempts(passwordID id: UUID) -> [PasswordAttempt] {
        
        print("fetching attempts for password \(id)")

        var attempts: [PasswordAttempt] = []
        do {
            
            let request = FetchDescriptor<PasswordAttempt>(
                predicate: #Predicate { $0.password == id },
                sortBy: [SortDescriptor(\.timestamp)]
            )
            attempts = try context.fetch(request)
            
            print("found \(attempts.count) attempts for password \(id)")
            
        } catch {
            print("fetching attempts failed: \(error)")
        }

        return attempts
    }
    
    @MainActor
    func createPasswordAttempt(attempt: PasswordAttempt) {
        context.insert(attempt)
        print("inserted attempt")
    }
    
    @MainActor
    func deleteAllAttempts(withID id: UUID) throws {
        let predicate = #Predicate<PasswordAttempt> { $0.password == id }
        try context.delete(model: PasswordAttempt.self, where: predicate)
        print("deleted all attempts for password \(id)")
    }
}
