//
//  Launchscreen.swift
//  Coder
//
//  Created by Mia Koring on 16.04.24.
//

import Foundation
import SwiftUI
struct Launchscreen: View{
    var body: some View{
        VStack{
            Image("AppIcon", bundle: .main)
            Text("Coder")
                .font(.title)
        }
    }
}
