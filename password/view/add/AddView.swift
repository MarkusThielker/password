//
//  AddView.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import SwiftUI

struct AddPasswordView: View {
    
    @ObservedObject var viewModel: ListViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var value: String = ""

    var body: some View {
        VStack {
            VStack {
                Text("Add Password")
                    .font(.title2)
                Text("Create a new password to learn.")
                Text("It will be encrypted and stored securely.")
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            Form {
                TextField("Name", text: $name)
                    .textFieldStyle(PwdTextFieldStyle())
                TextField("Value", text: $value)
                    .textFieldStyle(PwdTextFieldStyle())
            }
            
            Text("The password will not be visible again later. Make sure to save it somewhere else too!")
                .font(.footnote)
            HStack {
                PwdButton(label: Text("Save")) {
                    
                    if name.isEmpty || value.isEmpty {
                        let alert = NSAlert()
                        alert.messageText = "Missing values"
                        alert.informativeText = "Make sure to fill in both name and value!"
                        alert.addButton(withTitle: "Okay")
                        alert.runModal()
                        return
                    }
                    
                    viewModel.createPassword(name: name, value: value)
                    name = ""
                    value = ""
                    dismiss()
                }
                PwdButton(label: Text("Cancel"), variant: .outline) {
                    dismiss()
                }
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
        }.padding(20)
    }
}

#Preview {
    
    @Previewable
    @Environment(\.modelContext) var context
    
    AddPasswordView(viewModel: .init(context: context))
}
