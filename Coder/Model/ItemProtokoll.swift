//
//  ItemProtokoll.swift
//  Coder
//
//  Created by Mia Koring on 18.04.24.
//

import Foundation
protocol Item{
    var id: Int { get set }
    var timestamp: Double { get set }
    var hovered: Bool { get set }
    var deleteHovered: Bool { get set }
    var selected: Bool { get set }
}
