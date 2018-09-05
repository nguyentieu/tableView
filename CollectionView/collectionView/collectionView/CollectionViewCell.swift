//
//  CollectionViewCell.swift
//  collectionView
//
//  Created by nguyenos on 9/5/18.
//  Copyright © 2018 nguyenos. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    var mem: Member? {
        didSet{
            guard let mem = mem else { return }
            nameLabel.text = "Tên: " + mem.name!
            addressLabel.text = "Đ/c: " + mem.address!
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
