//
//  ViewController.swift
//  LetsTrade
//
//  Created by Gary Naz on 11/16/20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private lazy var dataSource = makeDataSource()

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>


    
    var myCollectionView : UICollectionView?
    let searchController = UISearchController(searchResultsController: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var barButton =  UIBarButtonItem(title: "Add Item", style: .plain, target: self, action: #selector(addItem))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNavConfig()
        
        myCollectionView?.delegate = self
        
        myCollectionView?.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.cellId)
        
//        applySnapshot(animatingDifferences: false, with: <#[Product]#>)
    }
    
    func applySnapshot(animatingDifferences: Bool = true, with product: [Product]) {
      var snapshot = Snapshot()
      snapshot.appendSections([.main])
      snapshot.appendItems(product)
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: myCollectionView!, cellProvider: {(collectionView, indexPath, Product) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.cellId, for: indexPath) as? ProductCell
            cell!.configure(title: "Test", price: 0, image: "ps4")
            return cell
        })
        return dataSource
    }
    
    
    func viewNavConfig(){
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: ViewController.createLayout())
        myCollectionView?.backgroundColor = .black
        
        view.addSubview(myCollectionView!)

        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = barButton
        searchController.hidesNavigationBarDuringPresentation = false
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout.init(section: section, configuration: UICollectionViewCompositionalLayoutConfiguration())
        return layout
    }
    
    @objc func addItem(){
        let destinationVc = NewProductViewController()
        let itemNavControler = UINavigationController(rootViewController: destinationVc)
        
        self.present(itemNavControler, animated: true, completion: nil)
    }
    
    
    enum Section {
        case main
    }
}






extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
