//
//  DataService.swift
//  CollectionView
//
//  Created by Kai Kim on 2022/03/24.
//

import Foundation
import UIKit
class DataManager {
    
    static let shared = DataManager()
    
    private init () {}
    
    func fetchJsonData() -> [URLModel]? {
        
        let pathString = Bundle.main.path(forResource: "doodle", ofType: "json")
        guard let pathString = pathString else {
            return nil
        }
        
        let url = URL(fileURLWithPath: pathString)
        
        do {
            let data = try Data(contentsOf: url)
            let decorder = JSONDecoder()
            
            do {
                let imageData = try decorder.decode([URLModel].self, from: data)
                return imageData
            }catch{
                print(error)
            }
            
        }catch {
            print(error)
        }
        return [URLModel]()
    }
    
    func downloadImage(url : URL, completion: @escaping (UIImage) -> ()) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                print("Download image fail : \(url)")
                return
            }
            completion(image)
            
        }.resume()
        
    }
    
    
}


