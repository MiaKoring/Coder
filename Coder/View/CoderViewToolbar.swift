import Foundation
import SwiftUI

struct CoderViewToolbar: View{
    @State var leftDeleteHovered = false
    @State var rightDeleteHovered = false
    @State var leftReverseHovered = false
    @State var rightReverseHovered = false
    @Binding var clear: String
    @Binding var encoded: String
    @Binding var algo: CodingAlgorithm
    
    var body: some View {
        HStack{
            HStack{
                Image(systemName: "xmark")
                    .toolbarImageModifier()
            }
            .toolbarItemModifier(hoverState: $leftDeleteHovered)
            .onTapGesture {
                clear = ""
            }
            HStack{
                Image(systemName: "arrow.left.arrow.right")
                    .allowsHitTesting(false)
            }
            .toolbarItemModifier(hoverState: $leftReverseHovered)
            .onTapGesture {
                clear = String(clear.reversed())
            }
            Spacer()
            Menu{
                Picker(selection: $algo){
                    ForEach(CodingAlgorithm.allCases, id: \.self){algorithm in
                        Text(LocalizedStringKey(algorithm.rawValue)).tag(algorithm).font(.title2)
                    }
                }label:{}
                    .pickerStyle(.inline)
            }label: {
                Text(LocalizedStringKey(algo.rawValue))
                    .font(.callout)
            }
            Spacer()
            HStack{
                Image(systemName: "arrow.left.arrow.right")
                    .allowsHitTesting(false)
            }
            .toolbarItemModifier(hoverState: $rightReverseHovered)
            .onTapGesture {
                encoded = String(encoded.reversed())
            }
            HStack{
                Image(systemName: "xmark")
                    .toolbarImageModifier()
            }
            .toolbarItemModifier(hoverState: $rightDeleteHovered)
            .onTapGesture {
                encoded = ""
            }
        }
    }
}
