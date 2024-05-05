import SwiftUI
import SwiftData

struct ContentView: View {
    
    //MARK: - Body

    var body: some View {
        NavigationSplitView {
            List {
                HStack {
                    Text(LocalizedStringKey("New"))
                        .allowsHitTesting(false)
                    Spacer()
                }
                .newDisplayModifier(selected: $newSelected, hovered: $newHovered)
                .onTapGesture {
                    newTapped()
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
                            storedTapped(item: item)
                        }
                        
                        HStack{
                            Image(systemName: "trash")
                                .allowsHitTesting(false)
                        }
                        .storedDisplayModifier(item: item, isDelete: true)
                        .onTapGesture{
                            deleteItem(item)
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
        .onChange(of: createNew){
            addItem()
        }
        .background(.opacity(0.0))
        .onAppear(){
            appeared()
        }
    }
    
    //MARK: - Params
    
    @Environment(\.modelContext) var context
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
    
    //MARK: -
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
