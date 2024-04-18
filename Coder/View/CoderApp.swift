//
//  CoderApp.swift
//  Coder
//
//  Created by Mia Koring on 16.04.24.
//

import SwiftData
import SwiftUI
import Sparkle

@main
struct CoderApp: App {
    @State var fontSize: Double = 14.0
    private let updaterController: SPUStandardUpdaterController
    init(){
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
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
            CommandGroup(after: .appInfo) {
                            CheckForUpdatesView(updater: updaterController.updater)
                        }
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
                UpdaterSettingsView(updater: updaterController.updater)
            }
    }
}
