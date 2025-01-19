//
//  DetailView.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    @State private var startTime: Date?
    @State private var elapsedTime: Double = -1
    @State private var value: String = ""
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
        
    func validateInput(input: String, password: Password) -> Bool {
        return input == viewModel.passwordKC.value
    }

    var body: some View {
        VStack {
            Text("Enter the password for \(viewModel.password.name) and submit with \"Enter\"")
            Form {
                SecureField("", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: value) { _, _ in
                        if (value.isEmpty){
                            startTime = nil
                        } else if startTime == nil {
                            startTime = Date()
                        }
                    }
                    .onSubmit {
                        if let startTime = startTime {
                            elapsedTime = Date().timeIntervalSince(startTime)
                        }
                        
                        let isSuccessful = validateInput(input: value, password: viewModel.password)
                        viewModel.createPasswordAttempt(isSuccessful: isSuccessful, typingTime: elapsedTime)
                        
                        if isSuccessful {
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
                        startTime = nil
                        elapsedTime = -1
                    }
            }
            HStack {
                Spacer()
                Text("Attempts: \(viewModel.statistics.totalCount)")
                Spacer()
                Text("Successful: \(viewModel.statistics.successCount) (\(viewModel.statistics.successRate, specifier: "%.2f")%)")
                Spacer()
                Text("Avg. time: \(viewModel.statistics.averageTime, specifier: "%.2f")s")
                Spacer()
            }
        }
        .padding()
    }
}
