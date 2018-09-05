//
//  AddMemberViewController.swift
//  TableView
//
//  Created by nguyenos on 9/5/18.
//  Copyright © 2018 nguyenos. All rights reserved.
//

import UIKit

class AddMemberViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func InsertButton(_ sender: Any) {
        
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
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
