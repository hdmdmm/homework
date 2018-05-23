//
//  UserListCell.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    static let cellID = "UserListCell"
    
    @IBOutlet weak var userPhotoImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // might be initialized fonts, color and styles.
    }
    
    func configure(with ownerData: OwnerModel?) {
        userPhotoImage.load(by: ownerData?.imgUrl)
        fullNameLabel.text = "\(ownerData?.name ?? "")\n\(ownerData?.surname ?? "")"
    }
}
