//
//  MovieCell.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import UIKit

protocol MovieCellDelegate: AnyObject {
    func didTapWatched(for movie: Movie)
}

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"
    
    private var movie: Movie?
    weak var delegate: MovieCellDelegate?

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let watchedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "👀 Visto"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let watchedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        watchedButton.addTarget(self, action: #selector(didTapWatchedButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(watchedLabel)
        contentView.addSubview(watchedButton)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),

            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            overviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            watchedLabel.leadingAnchor.constraint(equalTo: overviewLabel.leadingAnchor),
            watchedLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 5),

            watchedButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 5),
            watchedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            watchedButton.widthAnchor.constraint(equalToConstant: 30),
            watchedButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func configure(with movie: Movie, isWatched: Bool) {
        self.movie = movie
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        watchedLabel.textColor = isWatched ? .green : .gray
        watchedButton.tintColor = isWatched ? .green : .gray

        if let posterPath = movie.poster_path {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            downloadImage(from: URL(string: urlString))
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
    }

    private func downloadImage(from url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = UIImage(systemName: "photo")
    }

    @objc private func didTapWatchedButton() {
        guard let movie = movie else { return }
        delegate?.didTapWatched(for: movie)
    }
}

