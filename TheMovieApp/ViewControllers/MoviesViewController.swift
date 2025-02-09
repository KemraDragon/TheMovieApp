//
//  MoviesViewController.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesViewController: UIViewController, UITableViewDelegate {
    private let viewModel = MoviesViewModel()
    private let disposeBag = DisposeBag()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Buscar películas..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchMovies()
        tableView.delegate = self
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.filteredMovies
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: MovieCell.identifier, cellType: MovieCell.self)) { row, movie, cell in
                let isWatched = self.viewModel.isWatched(movie: movie)
                cell.configure(with: movie, isWatched: isWatched)
                cell.delegate = self
            }
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
    }
}

extension MoviesViewController: MovieCellDelegate {
    func didTapWatched(for movie: Movie) {
        guard let index = try? viewModel.allMovies.value().firstIndex(where: { $0.id == movie.id }) else { return }
        
        viewModel.toggleWatchedState(for: index)

        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


