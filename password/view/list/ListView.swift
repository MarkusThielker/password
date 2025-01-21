//
//  ListView.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct ListView: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: ListViewModel
    
    @State var isAddingPassword: Bool = false
    @State var selectedItem: UUID?

    var body: some View {
        NavigationStack {
            HStack {
                List {
                    HStack {
                        Text("Your passwords")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        PwdButton(
                            label: Image(systemName: "plus"),
                            variant: .primary,
                            size: .icon,
                            action: { isAddingPassword = true }
                        )
                        PwdButton(
                            label: Image(systemName: "arrow.trianglehead.clockwise")
                                .imageScale(.small),
                            variant: .primary,
                            size: .icon,
                            action: {
                                viewModel.passwords = viewModel.getAllPasswords()
                            }
                        )
                    }
                    .background(.clear)
                    .frame(maxWidth: .infinity)
                    
                    ForEach(viewModel.passwords) { password in
                        Button("\(password.name)") {
                            selectedItem = password.id
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .buttonStyle(PlainButtonStyle())
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(selectedItem == password.id ? .blue : .clear)
                        .foregroundColor(selectedItem == password.id ? .white : (colorScheme == .dark ? .white : .black))
                        .cornerRadius(8)
                    }
                }
                .frame(width: 250)
                .listStyle(SidebarListStyle())
                
                if let selectedItem = selectedItem {
                    DetailView(viewModel: DetailViewModel(context: context, passwordID: selectedItem))
                } else {
                    HStack {
                        Spacer()
                        Text("Select a password")
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .windowToolbarFullScreenVisibility(.onHover)
        .sheet(isPresented: $isAddingPassword) {
            AddPasswordView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.passwords = viewModel.getAllPasswords()
        }
    }
}

#Preview {
    
    @Previewable
    @Environment(\.modelContext) var context

    ListView(viewModel: .init(context: context))
}
