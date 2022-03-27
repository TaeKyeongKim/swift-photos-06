//
//  CustomMenuItem.swift
//  group6
//
//  Created by Kai Kim on 2022/03/27.
//
import Foundation

import UIKit

class CustomMenuItem: UIMenuItem {
    
    let indexPath : IndexPath
    
    
    init(title: String, action: Selector, indexPath : IndexPath) {
        self.indexPath = indexPath
        super.init(title: title, action: action)
    }
    
    
  
    
}
