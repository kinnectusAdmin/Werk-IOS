//
//  UIColor_ext.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import Foundation
import SwiftUI

extension UIColor {
    static var random: UIColor {
        UIColor(red: CGFloat.randomHex,
                green: CGFloat.randomHex,
                blue: CGFloat.randomHex,
                alpha: 1.0)
    }
}
