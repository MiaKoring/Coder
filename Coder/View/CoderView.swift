import Foundation
import SwiftUI
import Base32

struct CoderView: View{
    @State var clear: String = ""
    @State var encoded: String = ""
    @Binding var fontSize: Double
    @Binding var currentItem: CodedItem?
    @Binding var createNew: Bool
    @Binding var currentID: Int
    @State var showClearEmptyAlert = false
    @State var showEncodedEmptyAlert = false
    @State var showNotUTF8Alert = false
    @State var showEncodedNotFormatAlert = false
    @Binding var algo: CodingAlgorithm
    @Binding var startCodeItem: CodedItem?
    @Binding var cachedNew: CodedItem?
    @State var isNew = true
    @State var leftDeleteHovered = false
    @State var rightDeleteHovered = false
    
    var body: some View{
        HStack{
            TextEditor(text: $clear)
                .scrollIndicators(.never)
                .font(.system(size: fontSize))
                .overlay(alignment: .topTrailing){
                    HStack{
                        Image(systemName: "multiply")
                            .allowsHitTesting(false)
                    }
                    .padding(3)
                    .background(leftDeleteHovered ? Color("ItemBackgroundHovered") : Color("ItemBackgroundNormal"))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                    .padding(2)
                    .onHover(){ hovering in
                        leftDeleteHovered = hovering
                    }
                    .onTapGesture {
                        clear = ""
                    }
                }
                
            VStack{
                Image(systemName: "arrow.right")
                    .font(.title)
                    .padding()
                Button{
                    if clear.isEmpty{
                        showClearEmptyAlert = true
                        return
                    }
                    switch algo {
                    case .base64:
                        guard let data = clear.data(using: .utf8) else{
                            showNotUTF8Alert = true
                            return
                        }
                        encoded = data.base64EncodedString()
                        break
                    case .base32:
                        encoded = clear.base32EncodedString
                        break
                    case .base16:
                        encoded = clear.base16EncodedString
                    }
                    currentItem = CodedItem(clear: clear, coded: encoded, algo: algo, timestamp: Date().timeIntervalSince1970, id: currentID + 1)
                    createNew.toggle()
                }label: {
                    Text(LocalizedStringKey("encode"))
                }
                .alert(LocalizedStringKey("clearEmpty"), isPresented: $showClearEmptyAlert){
                    Button{
                        showClearEmptyAlert = false
                    }label: {
                        Text("OK")
                    }
                }
                .alert(LocalizedStringKey("notUTF-8"), isPresented: $showNotUTF8Alert){
                    Button{
                        showNotUTF8Alert = false
                    }label: {
                        Text("OK")
                    }
                }
                Button{
                    if encoded.isEmpty{
                        showEncodedEmptyAlert = true
                        return
                    }
                    switch algo {
                    case .base64:
                        guard let data = Data(base64Encoded: encoded) else{
                            showEncodedNotFormatAlert = true
                            return
                        }
                        guard let string = String(data: data, encoding: .utf8) else{
                            showNotUTF8Alert = true
                            return
                        }
                        clear = string
                    case .base32:
                        guard let string  = encoded.base32DecodedString() else{
                            showEncodedNotFormatAlert = true
                            return
                        }
                        clear = string
                    case .base16:
                        guard let string  = encoded.base16DecodedString() else{
                            showEncodedNotFormatAlert = true
                            return
                        }
                        clear = string
                    }
                    currentItem = CodedItem(clear: clear, coded: encoded, algo: algo, timestamp: Date().timeIntervalSince1970, id: currentID + 1)
                    createNew.toggle()
                }label: {
                    Text(LocalizedStringKey("decode"))
                }
                .alert(LocalizedStringKey("encodedEmpty"), isPresented: $showEncodedEmptyAlert){
                    Button{
                        showEncodedEmptyAlert = false
                    }label: {
                        Text("OK")
                    }
                }
                .alert(LocalizedStringKey("notFormatCompatible"), isPresented: $showEncodedNotFormatAlert){
                    Button{
                        showEncodedNotFormatAlert = false
                    }label: {
                        Text("OK")
                    }
                }
                Image(systemName: "arrow.left")
                    .font(.title)
                    .padding()
            }
            TextEditor(text: $encoded)
                .scrollIndicators(.never)
                .font(.system(size: fontSize))
                .overlay(alignment: .topTrailing){
                    HStack{
                        Image(systemName: "multiply")
                            .allowsHitTesting(false)
                    }
                    .padding(3)
                    .background(rightDeleteHovered ? Color("ItemBackgroundHovered") : Color("ItemBackgroundNormal"))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                    .padding(2)
                    .onHover(){ hovering in
                        rightDeleteHovered = hovering
                    }
                    .onTapGesture {
                        encoded = ""
                    }
                }

        }
        .onChange(of: startCodeItem){
            if startCodeItem != nil{
                if isNew{
                    cachedNew = CodedItem(clear: clear, coded: encoded, algo: algo, timestamp: Date().timeIntervalSince1970, id: -1)
                    isNew = false
                }
                clear = startCodeItem!.clear
                encoded = startCodeItem!.coded
                algo = CodingAlgorithm(rawValue: startCodeItem!.algo)!
            }
            else{
                isNew = true
                if cachedNew != nil{
                    clear = cachedNew!.clear
                    encoded = cachedNew!.coded
                    algo = CodingAlgorithm(rawValue: cachedNew!.algo)!
                    return
                }
                clear = ""
                encoded = ""
            }
        }
        .onAppear(){
            if startCodeItem != nil{
                clear = startCodeItem!.clear
                encoded = startCodeItem!.coded
                algo = CodingAlgorithm(rawValue: startCodeItem!.algo)!
                return
            }
            if cachedNew != nil{
                clear = cachedNew!.clear
                encoded = cachedNew!.coded
                algo = CodingAlgorithm(rawValue: cachedNew!.algo)!
            }
        }
    }
}
