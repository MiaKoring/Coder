import Foundation
import SwiftUI

extension ContentView{
    func addItem() {
        withAnimation {
            if currentItem != nil {
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
            
            if items.count >= 100 {
                let deleteItems = items[99...items.count - 1]
                for del in deleteItems{
                    context.delete(del)
                }
            }
        }
    }
    
    func deleteItem(_ item: CodedItem) {
        withAnimation {
            context.delete(item)
        }
    }
    
    func newTapped() {
        currentSelected?.selected = false
        currentSelected = nil
        newSelected = true
        startCodeItem = nil
        isNew = true
    }
    
    func storedTapped(item: CodedItem) {
        newSelected = false
        currentSelected?.selected = false
        currentSelected = item
        currentSelected!.selected = true
        startCodeItem = item
    }
    
    func appeared() {
        currentID = items.first?.id ?? 0
        
        let unselect = items.compactMap { item in
            if item.selected == true {
                return item
            }
            return nil
        }
        
        for un in unselect {
            un.selected = false
        }
    }
}
