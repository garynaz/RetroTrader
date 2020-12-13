//
//  ProductInfoViewController.swift
//  LetsTrade
//
//  Created by Gary Naz on 12/1/20.
//

import Foundation
import UIKit

class ProductInfoViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedProduct : Product?
    var imageArray : [UIImage]?
    
    var imageCollection : UICollectionView?
    
    
    let productTitle : UILabel = {
        let title = UILabel()
        title.backgroundColor = .white
        title.textColor = .black
        title.textAlignment = .left
        return title
    }()
    
    let productPrice : UILabel = {
        let price = UILabel()
        price.backgroundColor = .white
        price.textColor = .black
        price.textAlignment = .left
        return price
    }()
    
    let productDescription : UITextView = {
        let description = UITextView()
        description.backgroundColor = .white
        description.textColor = .black
        description.textAlignment = .left
        description.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return description
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollection = UICollectionView(frame: self.view.frame, collectionViewLayout: ProductInfoViewController.createLayout())
        imageCollection?.delegate = self
        imageCollection?.dataSource = self
        imageCollection?.register(imagePreviewCell.self, forCellWithReuseIdentifier: imagePreviewCell.cellId)
        imageCollection?.backgroundColor = .lightGray
        imageCollection?.isScrollEnabled = false
        
        productTitle.text = selectedProduct?.title
        productPrice.text = "$\(String(selectedProduct!.price))"
        productDescription.text = selectedProduct?.additionalInfo
        
        productTitle.setMargins(margin: 20)
        productPrice.setMargins(margin: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .lightGray
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        [productTitle, productPrice, productDescription, imageCollection!].forEach{view.addSubview($0)}
        layoutConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func layoutConfig() {
        imageCollection?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: view.frame.height/2, right: 0))
        productTitle.anchor(top: imageCollection!.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 380, right: 0))
        productPrice.anchor(top: productTitle.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 300, right: 0))
        productDescription.anchor(top: productPrice.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            
            return section
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  imageCollection!.dequeueReusableCell(withReuseIdentifier: imagePreviewCell.cellId, for: indexPath) as! imagePreviewCell
        
        cell.configure(image: imageArray![indexPath.row].pngData()!)
        
        return cell
    }
    
    
    //Produces a Data object from an Array of Images.
    func coreDataObjectFromImages(images: [UIImage]) -> Data? {
        let dataArray = NSMutableArray()
        
        for img in images {
            if let data = img.pngData() {
                dataArray.add(data)
            }
        }
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }
    
    
}

