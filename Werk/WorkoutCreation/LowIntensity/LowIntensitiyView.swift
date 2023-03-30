////
////  LowIntensitiyView.swift
////  Werk
////
////  Created by Shaquil Campbell on 2/5/23.
////
//
//import SwiftUI
//import Foundation
//import AVFoundation
//
//struct LowIntensitiyView: View {
//    var body: some View {
//        Form {
//            var viewModel = WorkoutCreationViewModel()
//            var model = WarmUpViewModel()
//            @Environment(\.presentationMode) var presentationMode
//            
//            
//            @State var bgColor =
//            Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
//            @State var isPickerPresented: Bool = false
//            @State var selectedSound = SystemSoundID()
//            var body: some View {
//                NavigationView{
//                    Form {
//                        Button("Duration") {
//                            isPickerPresented.toggle()
//                        }
//                        ColorPicker("Color", selection: $bgColor)
//                        Picker(selection: $selectedSound,label: Text("Sound")) {
//                            Text("Nonw")
//                            
//                        }
//                    }.navigationTitle("Warm Up")
//                }
//                .sheet(isPresented: $isPickerPresented) {
//                    picker()
//                    
//                }
//            }
//            
//            func picker() -> AnyView {
//                var columns = [
//                    DurationPicker.Column(label: "h", options: Array(0...23).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//                    DurationPicker.Column(label: "min", options: Array(0...59).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//                    DurationPicker.Column(label: "sec", options: Array(0...59).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//                ]
//                
//                var selection1: Int = 23
//                var selection2: Int = 59
//                var selection3: Int = 59
//                
//                return AnyView(DurationPicker(columns: columns, selections: [.constant(selection1), .constant(selection2), .constant(selection3)]).frame(height: 300).previewLayout(.sizeThatFits))
//            }
//
//        }
//    }
//}
//
//struct LowIntensitiyView_Previews: PreviewProvider {
//    static var previews: some View {
//        LowIntensitiyView()
//    }
//}
