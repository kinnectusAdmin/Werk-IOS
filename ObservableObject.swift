//
//  ObservableObject.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/4/22.
//

import Foundation

class ObservableObject<T>{
    var value: T?
    
    private var listener: ((T?) -> Void)?
    
    init(value: T? = nil) {
        self.value = value
    }
    
    func bind(_ listener: @escaping(T?) -> Void){
        listener(value) 
        self.listener = listener
    }
}
