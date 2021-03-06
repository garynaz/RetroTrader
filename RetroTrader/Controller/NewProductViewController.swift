//
//  NewProductViewController.swift
//  RetroTrader
//
//  Created by Gary Naz on 11/21/20.
//

import Foundation
import UIKit

class NewProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var bstSelector = UISegmentedControl(items: ["BUY","SELL","TRADE"])
    var selectedButtonTitle : String = "Buying"
    
    var lat : Double?
    var long : Double?
    var locName : String?
    let locationVC = selectLocationVC()
    var imageCollection : UICollectionView?
    var imgArray = [UIImage]()
    var imgConfig = UIImage.SymbolConfiguration(pointSize: 200, weight: .ultraLight, scale: .small)
    var selectedIndex : Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var barButton =  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    
    let titleField : UITextField = {
        let titleField = UITextField()
        titleField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        titleField.textColor = .black
        titleField.textAlignment = .center
        titleField.backgroundColor = .white
        titleField.addDoneCancelToolbar()
        return titleField
    }()
    
    let priceField : UITextField = {
        let priceField = UITextField()
        priceField.attributedPlaceholder = NSAttributedString(string: "Price", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        priceField.textColor = .black
        priceField.textAlignment = .center
        priceField.backgroundColor = .white
        priceField.keyboardType = .numberPad
        priceField.addDoneCancelToolbar()
        return priceField
    }()
    
    let additionalInfo : UITextView = {
        let description = UITextView()
        description.text = "Description"
        description.textColor = .lightGray
        description.textAlignment = .left
        description.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        description.backgroundColor = .white
        description.addDoneCancelToolbar()
        return description
    }()
    
    let locationButton : UIButton = {
        let locationButton = UIButton()
        locationButton.setTitleColor(UIColor.white, for: .normal)
        locationButton.backgroundColor = .systemIndigo
        locationButton.setTitle("Add Location", for: .normal)
        locationButton.addTarget(self, action: #selector(newLocation), for: .touchUpInside)
        return locationButton
    }()
    
    let postButton : UIButton = {
        let postButton = UIButton()
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.backgroundColor = .systemIndigo
        postButton.setTitle("Post Ad", for: .normal)
        postButton.addTarget(self, action: #selector(newPost), for: .touchUpInside)
        postButton.layer.cornerRadius = 10
        return postButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceField.delegate = self
        titleField.delegate = self
        additionalInfo.delegate = self
        locationVC.locationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .systemGray5
        navigationItem.leftBarButtonItem = barButton
        
        bstSelector.selectedSegmentIndex = 0
        bstSelector.addTarget(self, action: #selector(changeColor(sender:)), for: .valueChanged)
        let unselectedColor = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        let selectedColor = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        bstSelector.setTitleTextAttributes(unselectedColor, for: .normal)
        bstSelector.setTitleTextAttributes(selectedColor, for: .selected)
        
        [UIImage(systemName: "camera", withConfiguration: imgConfig)!, UIImage(systemName: "camera", withConfiguration: imgConfig)!, UIImage(systemName: "camera", withConfiguration: imgConfig)!, UIImage(systemName: "camera", withConfiguration: imgConfig)!, UIImage(systemName: "camera", withConfiguration: imgConfig)!, UIImage(systemName: "camera", withConfiguration: imgConfig)!].forEach{imgArray.append($0)}
        
        imageCollection = UICollectionView(frame: self.view.frame, collectionViewLayout: NewProductViewController.createLayout())
        imageCollection?.delegate = self
        imageCollection?.dataSource = self
        imageCollection?.register(AddImageCell.self, forCellWithReuseIdentifier: AddImageCell.cellId)
        imageCollection?.backgroundColor = .systemGray5
        imageCollection?.isScrollEnabled = true
        
        [titleField, priceField, additionalInfo, imageCollection!, postButton, locationButton, bstSelector].forEach{view.addSubview($0)}
        
        layoutConfig()
        setPaddingView(strImgname: "exclamationmark.circle", txtField: titleField)
        setPaddingView(strImgname: "exclamationmark.circle", txtField: priceField)
    }
    
    deinit {
        print("Release memory from New Product VC.")
    }
    
   @objc func changeColor(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedButtonTitle = "Buying"
        case 1:
            selectedButtonTitle = "Selling"
        case 2:
            selectedButtonTitle = "Trading"
        default:
            selectedButtonTitle = "Buying"
        }
    }
    
    func layoutConfig(){
        bstSelector.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 50))
        
        titleField.anchor(top: bstSelector.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 50))
        
        priceField.anchor(top: titleField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
        
        additionalInfo.anchor(top: priceField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 150))
        
        locationButton.anchor(top: additionalInfo.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
        
        imageCollection!.anchor(top: locationButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: postButton.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 30, right: 0))
        
        postButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 300, height: 70))
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setPaddingView(strImgname: String, txtField: UITextField){
        let imageView = UIImageView(image: UIImage(systemName: strImgname)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal))
        imageView.frame = CGRect(x: 0, y: 5, width: imageView.image!.size.width , height: imageView.image!.size.height)
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        paddingView.addSubview(imageView)
        txtField.rightViewMode = .always
        txtField.rightView = paddingView
        txtField.rightView?.isHidden = true
        txtField.setLeftPaddingPoints(50)
    }
    
    
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func newLocation(){
        //Add location services here...
        let locationNavController = UINavigationController(rootViewController: locationVC)
        locationNavController.modalPresentationStyle = .fullScreen
        locationNavController.modalTransitionStyle = .flipHorizontal
        self.present(locationNavController, animated: true, completion: nil)
    }
    
    
    @objc func newPost(){
        
        guard
            let title = titleField.text, !title.isEmpty,
            let price = priceField.text, !price.isEmpty,
            let itemDescription = additionalInfo.text, !itemDescription.isEmpty
        else
        {
            titleField.rightView?.isHidden = false
            priceField.rightView?.isHidden = false
            return
        }
        
        let newProduct = Product(context: context)
        newProduct.title = title
        newProduct.price = Int64(price)!
        newProduct.photo = coreDataObjectFromImages(images: imgArray)
        newProduct.additionalInfo = itemDescription
        newProduct.buySellTrade = selectedButtonTitle
        newProduct.latitude = lat ?? 37.3318
        newProduct.longitude = long ?? -122.0312
        newProduct.address = locName ?? "Apple Campus, CA 95014"
        do {
            try self.context.save()
        } catch {
            print("Error saving new Product: \(error)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets.leading = 20
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  imageCollection!.dequeueReusableCell(withReuseIdentifier: AddImageCell.cellId, for: indexPath) as! AddImageCell
        cell.configure(image: imgArray[indexPath.item].pngData()!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
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


extension NewProductViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imgArray[selectedIndex!] = image
            imageCollection?.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension NewProductViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if textField == titleField {
            let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.:!& "
            let allowedCharSet = CharacterSet(charactersIn: allowedChars)
            let typedCharsSet = CharacterSet(charactersIn: string)
            if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 20 {
                return true
            }
        } else {
            let allowedChars = "1234567890"
            let allowedCharSet = CharacterSet(charactersIn: allowedChars)
            let typedCharsSet = CharacterSet(charactersIn: string)
            if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 7 {
                return true
            }
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleField.rightView?.isHidden = true
        priceField.rightView?.isHidden = true
    }
    
}

extension NewProductViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let mytext = textView.text else { return true }
        let newLength = mytext.count + text.count - range.length
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.,:!@-&% "
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharsSet = CharacterSet(charactersIn: text)
        
        if (text == "\n") //Allows for Return key to function as a line break.
        {
            textView.text = textView.text + "\n"
        }
        
        if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 250 {
            return true
        }
        return false
    }
    
    
}

extension NewProductViewController : AddLocationDelegate {
    
    func didAddLocation(longitude: Double, latitude: Double, name: String) {
        lat = latitude
        long = longitude
        locName = name
    }
}
