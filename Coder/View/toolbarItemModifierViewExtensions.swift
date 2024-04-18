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
            .background(background(hoverState.wrappedValue))
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
            .onHover(){ hovering in
                withAnimation{
                    hoverState.wrappedValue = hovering
                }
            }
    }
    
    private func background(_ hovered: Bool) -> Color{
        hovered ? Color("ItemBackgroundHovered") : Color("ItemBackgroundNormal")
    }
}
