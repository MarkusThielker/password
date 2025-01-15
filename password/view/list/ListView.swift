//
//  ListView.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var viewModel: ListViewModel
    
    var body: some View {
        NavigationView {
            ForEach(viewModel.passwords) { password in
                NavigationLink(destination: Text(password.name)) {
                    Text(password.name)
                }
            }
        }
        .navigationTitle("Password Trainer")
    }
}

#Preview {
    ListView(viewModel: .init())
}
