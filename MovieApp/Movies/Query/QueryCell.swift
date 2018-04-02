//
//  QueryCell.swift
//  MovieApp
//
//  Created by Kyle Kendall on 4/1/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

/// Cell used to display a query
final class QueryCell: UITableViewCell, NibRegisterable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet private weak var queryLabel: UILabel!
    
    /// Call this early on to display the query correctly
    ///
    /// - Parameter query: Query to be displayed
    func configure(with query: Query) {
        queryLabel.text = query.term
    }
    
}
