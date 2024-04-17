//
//  ContentView.swift
//  Coder
//
//  Created by Mia Koring on 16.04.24.
//

import SwiftUI
import SwiftData
extension Bundle {
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(CodedItem.performanceDescriptor) var items: [CodedItem]
    @State var createNew = false
    @State var currentItem: CodedItem?
    @Binding var fontSize: Double
    @State var currentID = 0
    @State var defaultLinkActive = true
    @State var startCodeItem: CodedItem?
    @State var newHovered = false
    @State var newDeleteHovered = false
    @State var newSelected = true
    @State var currentSelected: CodedItem? = nil
    @State var cachedNew: CodedItem?
    @State var isNew = true

    var body: some View {
        NavigationSplitView {
            List {
                HStack{
                    HStack{
                        Text(LocalizedStringKey("New"))
                            .allowsHitTesting(false)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 40.0)
                    .background(newHovered ?
                                newSelected ?
                                Color("ItemBackgroundSelectedHovered"):
                                    Color("ItemBackgroundHovered") :
                                    newSelected ?
                                Color("ItemBackgroundSelectedNormal") :
                                    Color("ItemBackgroundNormal"))
                    .onTapGesture {
                        currentSelected?.selected = false
                        currentSelected = nil
                        newSelected = true
                        startCodeItem = nil
                        isNew = true
                    }
                    .onHover(){hovering in
                        withAnimation(.easeInOut(duration: 0.1)){
                            newHovered = hovering
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                Divider()
                    .padding(0)
                ForEach(items) { item in
                    HStack{
                        HStack{
                            Text(item.clear.dropLast(item.clear.count - 20 > 20 ? item.clear.count - 20 : 0))
                                .allowsHitTesting(false)
                            Spacer()
                        }
                        .padding()
                        .frame(height: 40.0)
                        .background(item.hovered ?
                                    item.selected ?
                                    Color("ItemBackgroundSelectedHovered"):
                                        Color("ItemBackgroundHovered") :
                                        item.selected ?
                                    Color("ItemBackgroundSelectedNormal") :
                                        Color("ItemBackgroundNormal"))
                        .onTapGesture {
                            newSelected = false
                            currentSelected?.selected = false
                            currentSelected = item
                            currentSelected!.selected = true
                            startCodeItem = item
                        }
                        .onHover(){hovering in
                            withAnimation(.easeInOut(duration: 0.1)){
                                item.hovered = hovering
                            }
                        }
                        
                        HStack{
                            Image(systemName: "trash")
                                .allowsHitTesting(false)
                        }
                        .padding()
                        .frame(height: 40.0)
                        .background(item.deleteHovered ? Color("ItemDeleteBackgroundHovered") : Color("ItemDeleteBackgroundNormal"))
                        .onHover{hovered in
                            withAnimation(.easeInOut(duration: 0.1)){
                                item.deleteHovered = hovered
                            }
                        }
                        .onTapGesture{
                            withAnimation{
                                deleteItem(item)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 200)
        } detail: {
            CoderView(fontSize: $fontSize, currentItem: $currentItem, createNew: $createNew, currentID: $currentID, startCodeItem: $startCodeItem, cachedNew: $cachedNew, isNew: $isNew)
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 200)
        .onAppear(){
            currentID = items.first?.id ?? 0
        }
        .onChange(of: createNew){
            addItem()
        }
        .background(.opacity(0.0))
        .onAppear(){
            let unselect = items.compactMap{item in
                if item.selected == true{
                    return item
                }
                return nil
            }
            for un in unselect{
                un.selected = false
            }
        }
        .onAppear(){
            print(Bundle.main.buildNumber)
        }
    }

    private func addItem() {
        withAnimation {
            if currentItem != nil{
                context.insert(currentItem!)
                currentID = currentItem!.id
                
                newSelected = false
                currentSelected?.selected = false
                currentSelected = currentItem
                currentSelected!.selected = true
                startCodeItem = currentItem
                currentItem = nil
                isNew = false
            }
            
            if items.count >= 100{
                let deleteItems = items[99...items.count - 1]
                for del in deleteItems{
                    context.delete(del)
                }
            }
        }
    }
    
    private func deleteItem(_ item: CodedItem){
        context.delete(item)
    }
}

struct ContentViewPreview: View {
    @State var fontSize = 8.0
    var body: some View {
         ContentView(fontSize: $fontSize)
    }
}

#Preview{
    ContentViewPreview()
        .modelContainer(for: CodedItem.self)
}
