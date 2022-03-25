//
//  CustomImageManager.swift
//  group6
//
//  Created by juntaek.oh on 2022/03/24.
//

import Foundation
import UIKit
import Photos

final class CustomPhotoManager: PHCachingImageManager{
    
    static let shared = CustomPhotoManager()
    private var fetchResult : PHFetchResult<PHAsset>?
    
    private(set) var thumbnailSize = CGSize(width: 100, height: 100)
    
    private override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    func changeThumbnailSize(width: Double, height: Double){
        self.thumbnailSize = CGSize(width: width, height: height)
    }
}


// MARK: - Use case: Fetch Asset and Request Images

extension CustomPhotoManager{
    func fetchResultCount() -> Int{
        return fetchResult?.count ?? 0
    }
    
    func getPHAsset(indexPath: IndexPath) -> PHAsset?{
        let asset = fetchResult?.object(at: indexPath.item)
        return asset
    }
    
    
    func requestImage(asset: PHAsset?, thumbnailSize: CGSize, completion: @escaping (UIImage?) -> Void){
        guard let asset = asset else {
            let noImage = UIImage(systemName: "multiply")
            completion(noImage)
            return
        }
        
        self.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .default, options: nil){ image, _ in
            completion(image)
        }
    }
    
    //Request Athorization & Fetch image
    func authorization(completion : @escaping () -> ()) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.fetchImage()
            self.startCachingPHAsset()
        }else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    self.fetchImage()
                    self.startCachingPHAsset()
                    completion()
                default :
                    //Alert User?
                    break
                }
            }
        }
    }
    
    func fetchImage() {
        self.fetchResult = PHAsset.fetchAssets(with: nil)
    }
    
    func startCachingPHAsset() {
        guard let assets = self.fetchResult else {return}
        let index : IndexSet = IndexSet(integersIn: 0..<assets.count)
        let assetArray : [PHAsset] = assets.objects(at: index)
        self.startCachingImages(for: assetArray, targetSize: self.thumbnailSize, contentMode: .aspectFit,  options: nil)
    }
    
    func reloadCollectionView(){
        NotificationCenter.default.post(name: .DidLoadPhoto, object: self, userInfo: nil)
    }
}


// MARK: - Use case: PHPhotoLibrary adopt

extension CustomPhotoManager: PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let previousFetchResult = fetchResult, let change = changeInstance.changeDetails(for: previousFetchResult) else { return }
        let newFetchResult = change.fetchResultAfterChanges
        let addedIndexPath = change.insertedIndexes
        let deletedIndexPath = change.removedIndexes
        
        
        if previousFetchResult.count < newFetchResult.count {
            self.fetchResult = PHAsset.fetchAssets(with: nil)
            NotificationCenter.default.post(name: .DidAddPhoto, object: self, userInfo: ["addedIndexPath":addedIndexPath as Any])
        }else {
            self.fetchResult = PHAsset.fetchAssets(with: nil)
            NotificationCenter.default.post(name: .DidDeletePhoto, object: self, userInfo: ["deletedIndexPath":deletedIndexPath as Any])
        }

    }
}

extension Notification.Name {
    static let DidLoadPhoto = Notification.Name("loadPhoto")
    static let DidAddPhoto = Notification.Name("AddPhoto")
    static let DidDeletePhoto = Notification.Name("DeletePhoto")
}
