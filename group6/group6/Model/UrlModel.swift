//
//  UrlModel.swift
//  group6
//
//  Created by Kai Kim on 2022/03/26.
//

import Foundation
import Foundation
class URLModel : Identifiable , Decodable, CustomStringConvertible{
    var description: String {
        return "Title: \(self.title), URL: \(self.image) Date: \(self.date)"
    }
    
    var title : String
    var image : URL
    var date : String
}
