//
//  AddMemberViewController.swift
//  collectionView
//
//  Created by nguyenos on 9/5/18.
//  Copyright © 2018 nguyenos. All rights reserved.
//

import UIKit

class AddMemberViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func insertToMember(_ sender: Any) {
        
        if ( nameTextField.text != "" && addressTextField.text != "") {
            let viewController = navigationController?.viewControllers[0] as! ViewController
            viewController.insertDataIntoPlist(nameTextField.text!, address: addressTextField.text!)
            navigationController?.popToViewController(viewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Lỗi", message: "Mời nhập đủ thông tin.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}
