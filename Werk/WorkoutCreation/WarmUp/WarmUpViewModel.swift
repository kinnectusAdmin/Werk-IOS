//
//  WarmUpViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import Foundation
import SwiftUI

class WarmUpViewModel: ObservableObject {
    @State var isPickerPresented: Bool = false
    
    
    
    
}


extension WarmUpViewModel {
    
    
    
    func picker() -> AnyView {
        var columns = [
            DurationPicker.Column(label: "h", options: Array(0...24).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
            DurationPicker.Column(label: "min", options: Array(0...60).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
            DurationPicker.Column(label: "sec", options: Array(0...60).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
        ]
        
        var selection1: Int = 0
        var selection2: Int = 0
        var selection3: Int = 0
        
        return AnyView(DurationPicker(columns: columns, selections: [.constant(selection1), .constant(selection2), .constant(selection3)]).frame(height: 300, alignment: .bottom).previewLayout(.sizeThatFits))
    }
}

