//
//  ListViewModel.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import Foundation

class ListViewModel: ObservableObject {
    
    @Published var passwords: [Password] = []
}
