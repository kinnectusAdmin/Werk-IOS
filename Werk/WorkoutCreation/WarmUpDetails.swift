//
//  WarmUpDetails.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/21/22.
//
import SwiftUI
import Foundation
import AVFoundation

struct WarmUpDetails: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    @State var bgColor =
    Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    @State var selectedSound = SystemSoundID()
    
    
    
    var body: some View {
        NavigationView{
            Form {
                
                
                ColorPicker("Color", selection: $bgColor)
                
                
                Picker(selection: $selectedSound,label: Text("Sound")) {
                    Text("dafgwage")
                    
                }
            }        .navigationTitle("Warm Up")
              
                            
                        
                    }
                    
                    
                }
            
        }
    
    

struct WarmUpView_Previews: PreviewProvider {
    static var previews: some View {
        WarmUpDetails()
    }
}
