//
//  CoderApp.swift
//  Coder
//
//  Created by Mia Koring on 16.04.24.
//

import SwiftData
import SwiftUI
import Sparkle

// This view model class publishes when new updates can be checked by the user
final class CheckForUpdatesViewModel: ObservableObject {
    @Published var canCheckForUpdates = false

    init(updater: SPUUpdater) {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }
}

// This is the view for our updater settings
// It manages local state for checking for updates and automatically downloading updates
// Upon user changes to these, the updater's properties are set. These are backed by NSUserDefaults.
// Note the updater properties should *only* be set when the user changes the state.
struct UpdaterSettingsView: View {
    private let updater: SPUUpdater
    
    @State private var automaticallyChecksForUpdates: Bool
    @State private var automaticallyDownloadsUpdates: Bool
    
    init(updater: SPUUpdater) {
        self.updater = updater
        self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
        self.automaticallyDownloadsUpdates = updater.automaticallyDownloadsUpdates
    }
    
    var body: some View {
        VStack {
            Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
                .onChange(of: automaticallyChecksForUpdates) { newValue in
                    updater.automaticallyChecksForUpdates = newValue
                }
            
            Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
                .disabled(!automaticallyChecksForUpdates)
                .onChange(of: automaticallyDownloadsUpdates) { newValue in
                    updater.automaticallyDownloadsUpdates = newValue
                }
        }.padding()
    }
}

// This is the view for the Check for Updates menu item
// Note this intermediate view is necessary for the disabled state on the menu item to work properly before Monterey.
// See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more info
struct CheckForUpdatesView: View {
    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
    private let updater: SPUUpdater
    
    init(updater: SPUUpdater) {
        self.updater = updater
        
        // Create our view model for our CheckForUpdatesView
        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
    }
    
    var body: some View {
        Button("Check for Updates…", action: updater.checkForUpdates)
            .disabled(!checkForUpdatesViewModel.canCheckForUpdates)
    }
}

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
