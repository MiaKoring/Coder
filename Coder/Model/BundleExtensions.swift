//
//  BundleExtensions.swift
//  Coder
//
//  Created by Mia Koring on 18.04.24.
//

import Foundation
extension Bundle {
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}
