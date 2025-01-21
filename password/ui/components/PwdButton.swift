//
//  Button.swift
//  password
//
//  Created by Markus Thielker on 19.01.25.
//

import SwiftUI

struct PwdButton<Label: View>: View {
        
    @Environment(\.colorScheme) private var colorScheme
    
    var label: Label
    var variant: ButtonVariant = .default
    var size: ButtonSize = .medium
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            label
        }
            .buttonStyle(PlainButtonStyle())
            .padding(size.padding)
            .background(variant.backgroundColor(colorScheme))
            .foregroundColor(variant.foregroundColor(colorScheme))
            .font(size.font)
            .cornerRadius(size.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .stroke(variant.borderColor(colorScheme), lineWidth: variant.borderWidth)
            )
    }
}

enum ButtonVariant {

    case `default`, primary, secondary, outline, ghost
    
    func backgroundColor(_ colorScheme: ColorScheme) -> Color {
        switch self {
        case .primary: return .blue
        case .secondary: return .gray
        case .outline, .ghost: return .clear
        default: return .blue
        }
    }
    
    func foregroundColor(_ colorScheme: ColorScheme) -> Color {
        switch self {
        case .primary, .secondary, .default: return .white
        case .outline, .ghost: return colorScheme == .dark ? .white : .black
        }
    }

    func borderColor(_ colorScheme: ColorScheme) -> Color {
        switch self {
        case .outline: return .gray
        default: return .clear
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .outline: return 1
        default: return 0
        }
    }
}

enum ButtonSize {
    case small, medium, large, icon

    var padding: EdgeInsets {
        switch self {
            case .small: return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            case .medium: return EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            case .large: return EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            case .icon: return EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        }
    }

    var font: Font {
        switch self {
        case .small: return .caption
        case .medium: return .body
        case .large: return .title3
        case .icon: return .body
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        case .icon: return 8
        }
    }
}

#Preview {
    VStack {
        
        PwdButton(
            label: Text("Click me!"),
            variant: .primary,
            action: {}
        )
        
        PwdButton(
            label: Text("Click me!"),
            variant: .secondary,
            action: {}
        )
        
        PwdButton(
            label: Text("Click me!"),
            variant: .outline,
            action: {}
        )
        
        PwdButton(
            label: Text("Click me!"),
            variant: .ghost,
            action: {}
        )
        
        PwdButton(
            label: Image(systemName: "plus"),
            variant: .primary,
            size: .icon,
            action: {}
        )
        
    }.padding()
}
