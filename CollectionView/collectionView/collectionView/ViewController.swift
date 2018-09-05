//
//  ViewController.swift
//  collectionView
//
//  Created by nguyenos on 9/5/18.
//  Copyright © 2018 nguyenos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    fileprivate let fileManager = FileManager.default
    
    fileprivate var members = [Member]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadDataFromBundlePlist()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        if let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.scrollDirection = .horizontal
            collectionViewFlowLayout.itemSize = CGSize.init(width: 150, height: 100)
            collectionViewFlowLayout.minimumLineSpacing = 10
            collectionViewFlowLayout.minimumInteritemSpacing = 10
        }
    }
    
    //
    func loadDataFromBundlePlist() {
        
        let path = documentDirectory.appending("/Member.plist")
        
        if !fileManager.fileExists(atPath: path) {
            if let bundleURL = Bundle.main.path(forResource: "Member", ofType: "plist") {
                try? fileManager.copyItem(atPath: bundleURL, toPath: path)
                
                guard let plistData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return }
                
                guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else { return }
                for memberInfo in result! {
                    let mem = Member.init(memberInfo["name"]!, memberInfo["address"]!)
                    members.append(mem)
                }
            }
        } else {
            guard let plistData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return }
            
            guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else { return }
            
            for memberInfo in result! {
                let mem = Member.init(memberInfo["name"]!, memberInfo["address"]!)
                members.append(mem)
            }
        }
    }
    
    func deleteUser(_ position: Int) {
        let path = documentDirectory.appending("/Member.plist")
        members.remove(at: position)
        
        if fileManager.fileExists(atPath: path) {
            try? fileManager.removeItem(atPath: path)
            var memberArray = [[String: String]]()
            members.forEach { mem in
                var memDictionary = [String: String]()
                memDictionary["name"] = mem.name
                memDictionary["address"] = mem.address
                memberArray.append(memDictionary)
            }
            (memberArray as NSArray).write(toFile: path, atomically: true)
        }
        collectionView.reloadData()
    }
    
    func insertDataIntoPlist(_ name: String, address: String) {
        let path = documentDirectory.appending("/Member.plist")
        
        let newUser = Member.init(name, address)
        members.insert(newUser, at: 0)
        
        if fileManager.fileExists(atPath: path) {
            try? fileManager.removeItem(atPath: path)
            var memberArray = [[String: String]]()
            members.forEach { mem in
                var memDictionary = [String: String]()
                memDictionary["name"] = mem.name
                memDictionary["address"] = mem.address
                memberArray.append(memDictionary)
            }
            (memberArray as NSArray).write(toFile: path, atomically: true)
        }
    }
    //
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell () }
        var mem = members[indexPath.row]
        cell.mem = mem
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var action = UIAlertController(title: "Chọn", message: "Chọn chức năng", preferredStyle: UIAlertControllerStyle.actionSheet)
        let deleteButton = UIAlertAction(title: "Xóa", style: UIAlertActionStyle.default) {
            (ACTION) in
            
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deleteUser(indexPath.row)
            })

            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
        
            self.present(dialogMessage, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            (ACTION) in
        }
        
        action.addAction(deleteButton)
        action.addAction(cancelButton)
        self.present(action, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 170, height: 100)
    }
}
