//
//  ViewController.swift
//  TableView
//
//  Created by nguyenos on 9/5/18.
//  Copyright © 2018 nguyenos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    fileprivate let fileManager = FileManager.default
    
    fileprivate var members = [Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadDataFromBundlePlist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    
    
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
        tableView.reloadData()
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
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .destructive, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deleteUser(indexPath.row)
            success(true)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        let mem = members[indexPath.row]
        tableViewCell.mem = mem
        return tableViewCell
    }
}
