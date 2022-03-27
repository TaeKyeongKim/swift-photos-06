//
//  DoodleViewController.swift
//  group6
//
//  Created by Kai Kim on 2022/03/26.
//

import UIKit
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
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(saveImage))
        longPressedGesture.minimumPressDuration = 1
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func saveImage (gestureRecognizer: UILongPressGestureRecognizer) {
        let p = gestureRecognizer.location(in: collectionView)

            if let indexPath = collectionView?.indexPathForItem(at: p) {
                print("Long press at item: \(indexPath.row)")
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

//MARK: gestureRecognizer  case
extension DoodleViewController : UIGestureRecognizerDelegate {

    //Scroll 과 long pressed 제스처가 동시에 인식됨.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
           return true
       }

}
