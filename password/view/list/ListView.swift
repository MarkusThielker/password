//
//  ListView.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var viewModel: ListViewModel
    @State var isAddingPassword: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.passwords) { password in
                    NavigationLink(destination: DetailView(password: password)) {
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
                    viewModel.loadAllPasswords()
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
            viewModel.loadAllPasswords()
        }
    }
}

#Preview {
    ListView(viewModel: .init())
}
