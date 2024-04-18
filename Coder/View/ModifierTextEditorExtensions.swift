//
//  ModifierTextEditorExtensions.swift
//  Coder
//
//  Created by Mia Koring on 18.04.24.
//

import Foundation
import SwiftUI
extension TextEditor{
    func defaultEditorModifier(fontSize: Double)-> some View{
        self
            .scrollIndicators(.never)
            .font(.system(size: fontSize))
    }
}
