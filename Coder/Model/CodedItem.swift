//
//  Item.swift
//  Coder
//
//  Created by Mia Koring on 16.04.24.
//

import Foundation
import SwiftData

@Model
final class CodedItem {
    var clear: String
    var coded: String
    var algo: CodingAlgorithm.RawValue
    var timestamp: Double
    var id: Int
    var hovered: Bool
    var deleteHovered: Bool
    var selected: Bool
    
    init(clear: String, coded: String, algo: CodingAlgorithm, timestamp: Double, id: Int, hovered: Bool = false, deleteHovered: Bool = false, selected: Bool = false) {
        self.clear = clear
        self.coded = coded
        self.algo = algo.rawValue
        self.timestamp = timestamp
        self.id = id
        self.hovered = hovered
        self.deleteHovered = deleteHovered
        self.selected = selected
    }
    
    public static var performanceDescriptor = {
        var descriptor = FetchDescriptor<CodedItem>()
        descriptor.sortBy = [SortDescriptor(\CodedItem.id, order: .reverse)]
        return descriptor
    }()
}

enum CodingAlgorithm: String, CaseIterable{
    case base64
    case base32
    case base16
}
