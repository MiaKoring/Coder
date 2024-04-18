//
//  StoredDisplayModifierViewExtensions.swift
//  Coder
//
//  Created by Mia Koring on 18.04.24.
//

import Foundation
import SwiftUI

extension View{
    func storedDisplayModifier(item: Item, isDelete: Bool = false) -> some View {
        var editableItem = item
        if !isDelete{
            return self
                .padding()
                .frame(height: 40.0)
                .background(selectableBackground(editableItem.selected, editableItem.hovered))
                .onHover(){hovering in
                    withAnimation(.easeInOut(duration: 0.1)){
                        editableItem.hovered = hovering
                    }
                }
        }
        return self
            .padding()
            .frame(height: 40.0)
            .background(backgroundColor(editableItem.deleteHovered, isDelete: true))
            .onHover{hovered in
                withAnimation(.easeInOut(duration: 0.1)){
                    editableItem.deleteHovered = hovered
                }
            }
    }
    
    func newDisplayModifier(selected: Binding<Bool>, hovered: Binding<Bool>) -> some View {
        self
            .padding()
            .frame(height: 40.0)
            .background(selectableBackground(selected.wrappedValue, hovered.wrappedValue))
            .onHover(){hovering in
                withAnimation(.easeInOut(duration: 0.1)){
                    hovered.wrappedValue = hovering
                }
            }
    }
    
    func buttonClipShape() -> some View {
        self
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
    private func selectableBackground(_ selected: Bool, _ hovered: Bool) -> Color {
        hovered ?
            selected ?
                Color("ItemBackgroundSelectedHovered"):
                Color("ItemBackgroundHovered") :
            selected ?
                Color("ItemBackgroundSelectedNormal") :
                Color("ItemBackgroundNormal")
    }
}
