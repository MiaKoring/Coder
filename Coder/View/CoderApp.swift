//
//  CoderApp.swift
//  Coder
//
//  Created by Mia Koring on 16.04.24.
//

import SwiftUI
import SwiftData

@main
struct CoderApp: App {
    @State var fontSize: Double = 14.0
    var body: some Scene {
        WindowGroup {
            ContentView(fontSize: $fontSize)
                .onAppear(){
                    UserDefaultHandler.setup()
                    fontSize = UserDefaultHandler.getFontSize()
                }
        }
        .modelContainer(for: CodedItem.self)
        .commands(){
            CommandMenu(LocalizedStringKey("appearance")){
                Button(LocalizedStringKey("bigger")){
                    fontSize = UserDefaultHandler.changeFontSize(.bigger)
                }
                .keyboardShortcut(.init("+"), modifiers: .command)
                Button(LocalizedStringKey("smaller")){
                    fontSize = UserDefaultHandler.changeFontSize(.smaller)
                }
                .keyboardShortcut(.init("-"), modifiers: .command)
            }
        }
    }
}
