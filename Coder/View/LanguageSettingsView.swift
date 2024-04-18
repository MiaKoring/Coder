//
//  LanguageSettingsView.swift
//  Coder
//
//  Created by Mia Koring on 18.04.24.
//

import Foundation
import SwiftUI

struct LanguageSettingsView: View {
    @State var selectedLanguage: Language = .system
    @State var currentLanguage: Language = .system
    @State var showLanguageChangedAlert = false
    
    var body: some View {
        HStack{
            Text(LocalizedStringKey("language"))
            Menu{
                Picker(selection: $selectedLanguage){
                    ForEach(Language.allCases, id: \.self){lang in
                        Text(LocalizedStringKey(lang.rawValue)).tag(lang).font(.title2)
                    }
                }label:{}
                    .pickerStyle(.inline)
            }label: {
                Text(LocalizedStringKey(selectedLanguage.rawValue))
                    .font(.callout)
            }
            .frame(width: 150)
            .onChange(of: selectedLanguage){
                UserDefaultHandler.setLanguage(selectedLanguage)
                if currentLanguage != selectedLanguage{
                    showLanguageChangedAlert = true
                }
            }
            .onAppear(){
                getLangueSetting()
            }
            .alert(LocalizedStringKey("languageChanged"), isPresented: $showLanguageChangedAlert){
                Button{
                    showLanguageChangedAlert = false
                }label: {
                    Text("OK")
                }
            }
        }
        .padding()
    }
    private func getLangueSetting(){
        let stored = UserDefaultHandler.getLanguage()
        currentLanguage = stored
        selectedLanguage = stored
    }
}
