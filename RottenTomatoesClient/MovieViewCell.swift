//
//  MovieViewCell.swift
//  RottenTomatoesClient
//
//  Created by Kevin Raymundo on 8/28/15.
//  Copyright (c) 2015 100kV. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterActivityIndicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
