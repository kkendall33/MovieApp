//
//  MovieCell.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/29/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

final class MovieCell: UITableViewCell, NibRegisterable {
    
    private static let imageService = ImageService()
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    private var movie: Movie?
    
    private var posterDownloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicatorView.isHidden = true
        posterImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with movieParameter: Movie) {
        nameLabel.text = movieParameter.name
        if let releaseDate = movieParameter.releaseDate {
            dateLabel.text = MovieCell.dateFormatter.string(from: releaseDate)
        } else {
            dateLabel.text = nil
        }
        overviewLabel.text = movieParameter.overview
        self.movie = movieParameter
        posterImageView.image = nil
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        guard let posterPath = movieParameter.posterServerPath else {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
            return
        }
        posterDownloadTask = MovieCell.imageService.downloadImage(with: posterPath, imageSize: .w185) { [weak self] url, error in
            DispatchQueue.main.async {
                defer {
                    self?.activityIndicatorView.stopAnimating()
                    self?.activityIndicatorView.isHidden = true
                }
                guard let _self = self else { return }
                guard let storedMovie = _self.movie, movieParameter == storedMovie else { return }
                guard let url = url else { return }
                let image = UIImage(contentsOfFile: url.path)
                _self.posterImageView.image = image
            }
        }
    }
    
}
