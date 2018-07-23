//
//  detayTableViewCell.swift
//  iosuygulama
//
//  Created by tolga iskender on 23.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit

class detayTableViewCell: UITableViewCell {

   
    @IBOutlet weak var resim: UIImageView!
    
    @IBOutlet weak var baslik: UILabel!
    
    
    @IBOutlet weak var detay: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
