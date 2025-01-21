//
//  ModernInputStyle.swift
//  password
//
//  Created by Markus Thielker on 19.01.25.
//

import SwiftUI

struct PwdTextFieldStyle: TextFieldStyle {
    
    @Environment(\.colorScheme) var colorScheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(colorScheme == .dark ? .black : .white)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .textFieldStyle(.plain)
            .cornerRadius(12)
    }
}
