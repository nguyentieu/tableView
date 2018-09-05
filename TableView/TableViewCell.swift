//
//  TableViewCell.swift
//  TableView
//
//  Created by nguyenos on 9/5/18.
//  Copyright © 2018 nguyenos. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var mem: Member? {
        didSet{
            guard let mem = mem else { return }
            nameLabel.text = "Tên : " + mem.name
            addressLabel.text = "Địa chỉ: " + mem.address
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
}
