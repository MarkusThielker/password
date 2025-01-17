//
//  passwordApp.swift
//  password
//
//  Created by Markus Thielker on 15.01.25.
//

import SwiftUI
import LocalAuthentication

@main
struct passwordApp: App {
    
    @State private var isAuthenticated = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "This app displays passwords in clear text. Please authenticate using Touch ID or Face ID."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isAuthenticated = true
                } else {
                    fallBackToPasscode()
                }
            }
        } else {
            fallBackToPasscode()
        }
    }
    
    func fallBackToPasscode() {
        let context = LAContext()
        let reason = "This app displays passwords in clear text. Please authenticate using your passcode."

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            if success {
                isAuthenticated = true
            } else {
                // Handle passcode authentication error
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if isAuthenticated {
                    ContextWrapper()
                } else {
                    Button("Authenticate") {
                        authenticate()
                    }
                }
            }
            .onAppear {
                authenticate()
            }
        }
        .modelContainer(for: [Password.self])
    }
}

struct ContextWrapper: View {
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        ListView(viewModel: ListViewModel(context: context))
    }
}
