//
//  unhittableTitle3ModifierViewExtension.swift
//  Coder
//
//  Created by Mia Koring on 18.04.24.
//

import Foundation
import SwiftUI

extension View{
    func toolbarImageModifier() -> some View{
        self
            .font(.title3)
            .allowsHitTesting(false)
    }
    func toolbarItemModifier(hoverState: Binding<Bool>) -> some View{
        self
            .padding(3)
            .background(backgroundColor(hoverState.wrappedValue))
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
            .onHover(){ hovering in
                withAnimation{
                    hoverState.wrappedValue = hovering
                }
            }
    }
    
    func backgroundColor(_ hovered: Bool, isDelete: Bool = false) -> Color{
        if !isDelete{
            return hovered ? Color("ItemBackgroundHovered") : Color("ItemBackgroundNormal")
        }
        return hovered ? Color("ItemDeleteBackgroundHovered") : Color("ItemDeleteBackgroundNormal")
    }
}
