//
//  passwordApp.swift
//  password
//
//  Created by Markus Thielker on 15.01.25.
//

import SwiftUI

@main
struct passwordApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(viewModel: ListViewModel())
        }
    }
}
