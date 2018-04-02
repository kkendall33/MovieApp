//
//  QueryCell.swift
//  MovieApp
//
//  Created by Kyle Kendall on 4/1/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

final class QueryCell: UITableViewCell, NibRegisterable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet private weak var queryLabel: UILabel!
    
    func configure(with query: Query) {
        queryLabel.text = query.term
    }
    
}
