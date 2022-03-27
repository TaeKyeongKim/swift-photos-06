//
//  ViewController.swift
//  group6
//
//  Created by Kai Kim on 2022/03/21.
//

import UIKit
import OSLog
class ViewController: UIViewController {
    private var collectionView: UICollectionView!

    private var size = CGSize(width: 100, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
        
        navigationConfigure()
        collectionViewConfigure()
        collectionViewDelegate()
        CustomPhotoManager.shared.authorization {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(loadAddedAsset), name: .DidAddPhoto, object: CustomPhotoManager.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(loadDeletedFetch), name: .DidDeletePhoto, object: CustomPhotoManager.shared)
    }
    
    @objc func loadAddedAsset(notification: Notification) {
        guard let addedIndexSet = notification.userInfo?["addedIndexPath"] as? IndexSet else {return}
        let indexPaths = addedIndexSet.map{IndexPath(row: $0, section: 0)}
        os_log("Photo Added")
        DispatchQueue.main.async {
            self.collectionView.insertItems(at: indexPaths)
        }
    }
    
    @objc func loadDeletedFetch(notification: Notification) {
        guard let deletedIndexSet = notification.userInfo?["deletedIndexPath"] as? IndexSet else {return}
        let indexPaths = deletedIndexSet.map{IndexPath(row: $0, section: 0)}
        os_log("Photo Deleted")
        DispatchQueue.main.async {
            self.collectionView.deleteItems(at: indexPaths)
        }
    }
    
}


// MARK: - Use case: Configure CollectionView

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CustomPhotoManager.shared.fetchResultCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.identifier, for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionCell, let asset = CustomPhotoManager.shared.getPHAsset(indexPath: indexPath) else {return UICollectionViewCell()}
        
        CustomPhotoManager.shared.requestImage(asset: asset, thumbnailSize: CustomPhotoManager.shared.thumbnailSize){ image in
            guard let image = image else {return}
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
        navigationLeftBarButtonConfigure()
    }
    
    private func navigationTitleConfigure(){
        self.title = "Photos"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 21) ?? UIFont()]
    }
    
    private func navigationRightBarButtonConfigure(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
    }
    
    private func navigationLeftBarButtonConfigure(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let doodleVC = DoodleViewController()
        let navVC = UINavigationController(rootViewController: doodleVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
}
