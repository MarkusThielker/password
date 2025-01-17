//
//  ListView.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct ListView: View {
    
    @ObservedObject var viewModel: ListViewModel
    @State var isAddingPassword: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.passwords) { password in
                    NavigationLink(destination: DetailView(
                        password: password,
                        passwordKC: viewModel.getPasswordKeychain(withID: password.id)!
                    )) {
                        Text(password.name)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .toolbar {
                Button(action: { isAddingPassword = true }) {
                    Image(systemName: "plus")
                        .frame(width: 20, height: 20)
                }
                Button(action: {
                    viewModel.getAllPasswords()
                }) {
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .imageScale(.medium)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .navigationTitle("Password Trainer")
        .sheet(isPresented: $isAddingPassword) {
            AddPasswordView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.getAllPasswords()
        }
    }
}

#Preview {
    
    @Previewable
    @Environment(\.modelContext) var context

    ListView(viewModel: .init(context: context))
}
