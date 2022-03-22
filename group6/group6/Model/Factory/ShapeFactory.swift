//
//  ShapeFactory.swift
//  group6
//
//  Created by Kai Kim on 2022/03/22.
//

import Foundation

class ShapeFactory {
    
    
    func makeShapes(num: UInt8, width : Double = 80, height : Double = 80) -> [CustomShape]{
        
        var shapes = [CustomShape]()
        guard width > 0.0 && height > 0.0 else {return shapes}
        for _ in 0..<num {
            shapes.append(CustomShape(id: makeID(), color: makeColor(), size: makeSize(width: width, height: height)))
        }
        return shapes
    }
    
    private func makeID() -> String {
        var UUID = UUID().uuidString.components(separatedBy: "-")
        for i in 1..<4 {
            UUID[i].removeFirst()
        }
        return UUID[1..<4].joined(separator:"-")
    }
    
    private func makeSize(width : Double, height: Double) -> CustomSize {
        CustomSize(width: width, height: height)
    }
    
    private func makeColor() -> CustomColor {
        let Redrandom = Double.random(in: 0...255)
        let Greenrandom = Double.random(in: 0...255)
        let Bluerandom = Double.random(in: 0...255)
        return CustomColor(red: Redrandom, green: Greenrandom, blue: Bluerandom)
    }
    
    
    
}
