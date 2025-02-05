//
//  MovieCell.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        if let posterPath = movie.poster_path, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
            downloadImage(from: posterURL) // ✅ Ahora usa posterPath correctamente
        } else {
            posterImageView.image = UIImage(systemName: "photo") // Placeholder si no hay imagen
        }
    }
    
    private func downloadImage(from url: URL?) {
        guard let url = url else { return }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(systemName: "photo") // Imagen fallback si hay error
                }
            }
        }
    }
}
