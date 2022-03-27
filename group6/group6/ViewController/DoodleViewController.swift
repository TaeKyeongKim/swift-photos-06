//
//  DoodleViewController.swift
//  group6
//
//  Created by Kai Kim on 2022/03/26.
//

import UIKit
import Photos
class DoodleViewController : UIViewController {

    private var collectionView: UICollectionView!

    private var URLModels : [URLModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationConfigure()
        collectionViewConfigure()
        collectionViewDelegate()
        setupGesture()
        fetchURL()
      
    }
    
    func fetchURL () {
        self.URLModels = DataManager.shared.fetchJsonData()
    }
    
    func collectionViewConfigure(){
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.register(DoodleCollectionCell.self, forCellWithReuseIdentifier: DoodleCollectionCell.identifier)
        self.view.addSubview(collectionView)
    }
            
    func collectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupGesture() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(selectCell))
        longPressedGesture.minimumPressDuration = 1
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func selectCell (gestureRecognizer: UILongPressGestureRecognizer) {
        let p = gestureRecognizer.location(in: collectionView)
        guard let indexPath = collectionView?.indexPathForItem(at: p) else {return}
        guard let selectedCell = collectionView.cellForItem(at: indexPath) else {return}
        selectedCell.becomeFirstResponder()
        
        UIMenuController.shared.arrowDirection = .default
        UIMenuController.shared.showMenu(from: selectedCell, rect: selectedCell.bounds)
        let menuItem = CustomMenuItem(title: "Save", action: #selector(downloadImage(sender:)), indexPath: indexPath)
        UIMenuController.shared.menuItems = [menuItem]
    }
    
    @objc func downloadImage(sender: UIMenuController) {
        
        guard let saveMenuItem = sender.menuItems?.first as? CustomMenuItem else {return}
        guard let selectedModel = self.URLModels?[saveMenuItem.indexPath.item] else {return}
        DataManager.shared.downloadImage(url: selectedModel.image) { image in
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
}

//MARK: navigation configuration case

extension DoodleViewController {
    
    func navigationConfigure() {
       navigationTitleConfigure()
       navigationRightBarButtonConfigure()
    }
    
    
    private func navigationTitleConfigure(){
        self.title = "Doodles"
        view.backgroundColor = .darkGray

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 21) ?? UIFont()]
    }
    
    private func navigationRightBarButtonConfigure(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dissmissDoodles))
    }
    
    @objc func dissmissDoodles () {
        self.dismiss(animated: true)
    }
    
}

//MARK: CollectionVeiw case

extension DoodleViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cellCount = URLModels?.count else {return 0}
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoodleCollectionCell.identifier, for: indexPath)
        
        guard let doodleCell = cell as? DoodleCollectionCell, let models = self.URLModels else {return UICollectionViewCell()}
        
        DataManager.shared.downloadImage(url: models[indexPath.item].image) { image in
            DispatchQueue.main.async {
                doodleCell.setImage(image: image)
            }
        }
        return doodleCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 50)
    }
}

