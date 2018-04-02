//
//  NibRegisterable.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

// Careem: I wrote NibRegisterable to clean up tableViews. Just make your `UITableViewCell` subclass
// conform to this (literally just `class MyCell: UITableViewCell, NibRegisterable`) and
// then you can get `tableView.register(MyCell.self)` for free
// and `let cell: MyCell tableView.dequeueCell(indexPath: indexPath)`.
// I LOVE this thing. It has simplified tables a lot for me and I feel it's pretty intuitive.

import UIKit


/// Conform to this to get an identifier for free. Normally used with UITableViewCell.
public protocol ReuseIdentifying: class {
    // See extension
}

public extension ReuseIdentifying {
    public static var reuseIdentifier: String {
        return String(describing: Self.self) + "Identifier"
    }
}


public protocol NibRegisterable: ReuseIdentifying, Nibbed { }


public extension UITableView {
    
    public func register(_ nibRegisterable: NibRegisterable.Type) {
        register(nibRegisterable.nib, forCellReuseIdentifier: nibRegisterable.reuseIdentifier)
    }
    
    public func register(_ reuseIdentifying: ReuseIdentifying.Type) {
        register(reuseIdentifying, forCellReuseIdentifier: reuseIdentifying.reuseIdentifier)
    }
    
    func dequeueCell<T: UITableViewCell & ReuseIdentifying>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.self.reuseIdentifier) as? T else {
            fatalError("You must register your cell with `tableView.register(_ nibRegisterable: NibRegisterable.Type)` or other `register` methods on `UITableView`.")
        }
        return cell
    }
    
    func dequeueCell<T: UITableViewCell & ReuseIdentifying>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.self.reuseIdentifier, for: indexPath) as? T else {
            fatalError("You must register your cell with `tableView.register(_ nibRegisterable: NibRegisterable.Type)` or other `register` methods on `UITableView`.")
        }
        return cell
    }
    
}

