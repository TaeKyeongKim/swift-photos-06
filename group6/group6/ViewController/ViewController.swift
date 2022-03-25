//
//  ViewController.swift
//  group6
//
//  Created by Kai Kim on 2022/03/21.
//

import UIKit

class ViewController: UIViewController {
    private var collectionView: UICollectionView!

    private var size = CGSize(width: 100, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
        
        navigationConfigure()
        collectionViewConfigure()
        collectionViewDelegate()
        CustomPhotoManager.shared.fetchPHAsset()
    }
    
    func collectionViewConfigure(){
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: PhotoCollectionCell.identifier)
        
        self.view.addSubview(collectionView)
    }
            
    func collectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}


// MARK: - Use case: add Notification / Noti function

extension ViewController{
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: CustomPhotoManager.NotificationName.reloadCollectionView, object: CustomPhotoManager.shared)
    }
    
    @objc func reloadCollectionView(){
        self.collectionView.reloadData()
    }
}


// MARK: - Use case: Configure CollectionView

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CustomPhotoManager.shared.fetchResultCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.identifier, for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionCell, let asset = CustomPhotoManager.shared.getImage(indexPath: indexPath) else {return UICollectionViewCell()}
        
        CustomPhotoManager.shared.requestImage(asset: asset, thumbnailSize: CustomPhotoManager.shared.thumbnailSize){ image in
            photoCell.setImage(image: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}


// MARK: - Use case: Configure NavigationBar

extension ViewController{
    private func navigationConfigure(){
        navigationTitleConfigure()
        navigationRightBarButtonConfigure()
    }
    
    private func navigationTitleConfigure(){
        self.title = "Photos"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 21) ?? UIFont()]
    }
    
    private func navigationRightBarButtonConfigure(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
    }
}
