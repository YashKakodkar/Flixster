//
//  MovieCell.swift
//  Flixster
//
//  Created by Yash Kakodkar on 1/28/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import Alamofire

class MovieCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
