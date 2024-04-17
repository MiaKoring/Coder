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
    @State var algo: CodingAlgorithm = .base64
    @Binding var startCodeItem: CodedItem?
    @Binding var cachedNew: CodedItem?
    @Binding var isNew: Bool
    @State var leftDeleteHovered = false
    @State var rightDeleteHovered = false
    @State var leftReverseHovered = false
    @State var rightReverseHovered = false
    
    var body: some View{
        HStack{
            TextEditor(text: $clear)
                .scrollIndicators(.never)
                .font(.system(size: fontSize))
                
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
                    let alias = encoded.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
                    switch algo {
                    case .base64:
                        guard let data = Data(base64Encoded: alias) else{
                            showEncodedNotFormatAlert = true
                            return
                        }
                        guard let string = String(data: data, encoding: .utf8) else{
                            showNotUTF8Alert = true
                            return
                        }
                        clear = string
                    case .base32:
                        guard let string  = alias.base32DecodedString() else{
                            showEncodedNotFormatAlert = true
                            return
                        }
                        clear = string
                    case .base16:
                        guard let string  = alias.base16DecodedString() else{
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
        .toolbar{
            ToolbarItem(placement: .accessoryBar(id: 1)){
                HStack{
                    HStack{
                        Image(systemName: "xmark")
                            .font(.title3)
                            .allowsHitTesting(false)
                    }
                    .padding(3)
                    .background(leftDeleteHovered ? Color("ItemBackgroundHovered") : Color("ItemBackgroundNormal"))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                    .onHover(){ hovering in
                        withAnimation{
                            leftDeleteHovered = hovering
                        }
                    }
                    .onTapGesture {
                        clear = ""
                    }
                    HStack{
                        Image(systemName: "arrow.left.arrow.right")
                            .allowsHitTesting(false)
                    }
                    .padding(3)
                    .background(leftReverseHovered ? Color("ItemBackgroundHovered") : Color("ItemBackgroundNormal"))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                    .onHover(){ hovering in
                        withAnimation{
                            leftReverseHovered = hovering
                        }
                    }
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
                    .padding(3)
                    .background(rightReverseHovered ? Color("ItemBackgroundHovered") : Color("ItemBackgroundNormal"))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                    .onHover(){ hovering in
                        withAnimation{
                            rightReverseHovered = hovering
                        }
                    }
                    .onTapGesture {
                        encoded = String(encoded.reversed())
                    }
                    HStack{
                        Image(systemName: "xmark")
                            .font(.title3)
                            .allowsHitTesting(false)
                    }
                    .padding(3)
                    .background(rightDeleteHovered ? Color("ItemBackgroundHovered") : Color("ItemBackgroundNormal"))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                    .onHover(){ hovering in
                        withAnimation{
                            rightDeleteHovered = hovering
                        }
                    }
                    .onTapGesture {
                        encoded = ""
                    }
                }
            }
        }
    }
}
