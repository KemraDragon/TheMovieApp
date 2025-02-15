//
//  DetailViewController.swift
//  TheMovieApp
//
//  Created by Sebastian Cerda Fuentes on 15-02-25.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {

    private let viewModel: MovieDetailViewModel
    private let disposeBag = DisposeBag()

    // UI Elements
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let movieIDLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let revenueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Inicializador con ViewModel
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // Configurar la UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(ratingLabel)
        view.addSubview(movieIDLabel)
        view.addSubview(genresLabel)
        view.addSubview(runtimeLabel)
        view.addSubview(revenueLabel)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            movieIDLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            movieIDLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            movieIDLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            genresLabel.topAnchor.constraint(equalTo: movieIDLabel.bottomAnchor, constant: 10),
            genresLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genresLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            revenueLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 10),
            revenueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            revenueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            runtimeLabel.topAnchor.constraint(equalTo: revenueLabel.bottomAnchor, constant: 10),
            runtimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            runtimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    // Enlazar ViewModel con la Vista
    private func bindViewModel() {
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.releaseDate.bind(to: releaseDateLabel.rx.text).disposed(by: disposeBag)
        viewModel.rating.bind(to: ratingLabel.rx.text).disposed(by: disposeBag)
        viewModel.movieID.bind(to: movieIDLabel.rx.text).disposed(by: disposeBag)
        viewModel.revenue.bind(to: revenueLabel.rx.text).disposed(by: disposeBag)
        viewModel.runtime.bind(to: runtimeLabel.rx.text).disposed(by: disposeBag)
        viewModel.genres.bind(to: genresLabel.rx.text).disposed(by: disposeBag)

        viewModel.posterURL.subscribe(onNext: { [weak self] url in
            guard let self = self, let url = url else { return }
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = image
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
}

