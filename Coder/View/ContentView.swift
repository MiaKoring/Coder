//
//  ContentView.swift
//  Coder
//
//  Created by Mia Koring on 16.04.24.
//

import SwiftUI
import SwiftData

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
                    .newDisplayModifier(selected: $newSelected, hovered: $newHovered)
                    .onTapGesture {
                        currentSelected?.selected = false
                        currentSelected = nil
                        newSelected = true
                        startCodeItem = nil
                        isNew = true
                    }
                }
                .buttonClipShape()
                Divider()
                    .padding(0)
                ForEach(items) { item in
                    HStack{
                        HStack{
                            Text(item.clear.dropLast(item.clear.count - 20 > 20 ? item.clear.count - 20 : 0))
                                .allowsHitTesting(false)
                            Spacer()
                        }
                        .storedDisplayModifier(item: item)
                        .onTapGesture {
                            newSelected = false
                            currentSelected?.selected = false
                            currentSelected = item
                            currentSelected!.selected = true
                            startCodeItem = item
                        }
                        
                        HStack{
                            Image(systemName: "trash")
                                .allowsHitTesting(false)
                        }
                        .storedDisplayModifier(item: item, isDelete: true)
                        .onTapGesture{
                            withAnimation{
                                deleteItem(item)
                            }
                        }
                    }
                    .buttonClipShape()
                    
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
