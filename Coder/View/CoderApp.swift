//
//  CoderApp.swift
//  Coder
//
//  Created by Mia Koring on 16.04.24.
//

import SwiftData
import SwiftUI

@main
struct CoderApp: App {
    @State var fontSize: Double = 14.0
    @State var language: Language = .system
    
    var body: some Scene {
        WindowGroup {
            ContentView(fontSize: $fontSize)
                .onAppear(){
                    UserDefaultHandler.setup()
                    fontSize = UserDefaultHandler.getFontSize()
                    language = UserDefaultHandler.getLanguage()
                }
                .environment(\.locale, .init(identifier: language.rawValue))
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
        Settings {
                LanguageSettingsView()
                .environment(\.locale, .init(identifier: language.rawValue))
        }
    }
}
