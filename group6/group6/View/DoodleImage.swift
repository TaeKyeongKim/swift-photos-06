//
//  DoodleImage.swift
//  group6
//
//  Created by Kai Kim on 2022/03/26.
//

import Foundation
import UIKit

class DoodleCollectionCell: UICollectionViewCell{
    static let identifier: String = "DoodleCollectionCell"
    
    private let imageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        imageView.frame = self.contentView.bounds
        contentView.addSubview(imageView)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = self.contentView.bounds
        contentView.addSubview(imageView)
    }
    
    func setImage(image: UIImage){
        self.imageView.image = image
    }
    
    func checkImage() -> UIImage?{
        return self.imageView.image
    }
}
