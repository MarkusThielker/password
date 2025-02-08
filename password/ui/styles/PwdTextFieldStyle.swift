//
//  ModernInputStyle.swift
//  password
//
//  Created by Markus Thielker on 19.01.25.
//

import SwiftUI

struct PwdTextFieldStyle: TextFieldStyle {
    
    @Environment(\.colorScheme) var colorScheme
    
    private let radius: CGFloat = 12
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(colorScheme == .dark ? .black.opacity(0.1) : .white)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .textFieldStyle(.plain)
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(.gray, lineWidth: 1)
            )
    }
}
