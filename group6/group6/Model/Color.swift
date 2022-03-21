//
//  Color.swift
//  group6
//
//  Created by Kai Kim on 2022/03/21.
//

import Foundation
class Color {
    let red : Double
    let green : Double
    let blue : Double
    let range = 0.0...255.0
    var description: String {
        return "R:\(red.trim), G:\(green.trim), B:\(blue.trim)"
    }
    
    init(r:Double, g: Double, b:Double){
        //각각의 rgb 가 0~255 사이의 값이 아닐시 0으로 설정해준다.
        var values = [r,g,b]
        for i in 0..<values.count {
            if !range.contains(values[i]){
                values[i] = 0.0
            }
        }
        
        self.red = values[0]
        self.green = values[1]
        self.blue = values[2]
        
    }
    
    var tohexString : String {
        let rgb:Int = (Int)(self.red)<<16 | (Int)(self.green)<<8 | (Int)(self.blue)<<0
        return String(format:"#%06x", rgb)
    }
}
