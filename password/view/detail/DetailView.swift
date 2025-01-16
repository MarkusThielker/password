//
//  DetailView.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import SwiftUI

struct DetailView: View {
    
    let password: Password
    @State var value: String = ""

    func validateInput(input: String, password: Password) -> Bool {
        return input == password.value
    }
    
    var body: some View {
        VStack {
            Text("Enter the password for \(password.name)")
            Form {
                SecureField("", text: $value)
                Button("Submit") {
                    let correct = validateInput(input: value, password: password)
                    
                    if (correct) {
                        let alert = NSAlert()
                        alert.messageText = "Correct"
                        alert.informativeText = "That one was correct!"
                        alert.addButton(withTitle: "Let's go!")
                        alert.runModal()
                    } else {
                        let alert = NSAlert()
                        alert.messageText = "Not quite"
                        alert.informativeText = " That one was not quite right! Try again!"
                        alert.addButton(withTitle: "Okay")
                        alert.runModal()
                    }
                    
                    value = ""
                }
            }
        }
        .padding()
    }
}

#Preview {
    let password = Password(name: "macbook", value: "password")
    DetailView(password: password)
}
