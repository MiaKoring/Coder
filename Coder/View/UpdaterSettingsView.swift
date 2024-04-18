//
//  UpdaterSettingsView.swift
//  Coder
//
//  Created by Mia Koring on 18.04.24.
//

import Foundation
import SwiftUI
import Sparkle

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
                .onChange(of: automaticallyChecksForUpdates) { newValue, _ in
                    updater.automaticallyChecksForUpdates = newValue
                }
            
            Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
                .disabled(!automaticallyChecksForUpdates)
                .onChange(of: automaticallyDownloadsUpdates) { newValue, _ in
                    updater.automaticallyDownloadsUpdates = newValue
                }
        }.padding()
    }
}
