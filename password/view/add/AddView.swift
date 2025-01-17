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
                    .font(.headline)
                Text("Create a new password to learn. It will be encrypted and stored securely.")
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            Form {
                TextField("Name", text: $name)
                TextField("Value", text: $value)
                Text("The password will not be visible again later. Make sure to save it somewhere else too!")
                    .font(.footnote)
                HStack {
                    Button("Save") {
                        viewModel.createPassword(name: name, value: value)
                        name = ""
                        value = ""
                        dismiss()
                    }
                    Button("Cancel") {
                        dismiss()
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            }
        }.padding(20)
    }
}

#Preview {
    
    @Previewable
    @Environment(\.modelContext) var context
    
    AddPasswordView(viewModel: .init(context: context))
}
