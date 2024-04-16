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
    @State var algo: CodingAlgorithm = .base64
    @Binding var fontSize: Double
    @State var currentID = 0
    @State var defaultLinkActive = true
    @State var startCodeItem: CodedItem?
    @State var newHovered = false
    @State var newDeleteHovered = false
    @State var newSelected = true
    @State var currentSelected: CodedItem? = nil
    @State var cachedNew: CodedItem?

    var body: some View {
        NavigationSplitView {
            List {
                HStack{
                    HStack{
                        Text("New")
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
            CoderView(fontSize: $fontSize, currentItem: $currentItem, createNew: $createNew, currentID: $currentID, algo: $algo, startCodeItem: $startCodeItem, cachedNew: $cachedNew)
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 200)
        .onAppear(){
            currentID = items.first?.id ?? 0
        }
        .onChange(of: createNew){
            addItem()
        }
        .background(.opacity(0.0))
        .toolbar {
            ToolbarItem(placement: .principal){
                Picker(LocalizedStringKey("algo"), selection: $algo){
                    Text(LocalizedStringKey("base64")).tag(CodingAlgorithm.base64)
                    Text(LocalizedStringKey("base32")).tag(CodingAlgorithm.base32)
                    Text(LocalizedStringKey("base16")).tag(CodingAlgorithm.base16)
                }
                .labelsHidden()
            }
        }
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
                currentItem = nil
            }
            
            if items.count >= 100{
                let deleteItems = items[99...items.count - 1]
                for del in deleteItems{
                    context.delete(del)
                    print("deleted \(del)")
                }
            }
        }
    }
    
    private func deleteItem(_ item: CodedItem){
        print(items.count)
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
