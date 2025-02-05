//
//  MoviesViewController.swift
//  TheMovieApp
//
//  Created by Kevin on 05-02-25.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesViewController: UIViewController {

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
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchMovies()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)

        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)

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
        let searchObservable = searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()

        searchObservable
            .bind(to: viewModel.searchQuery) // ✅ Se enlaza correctamente con searchQuery
            .disposed(by: disposeBag)

        viewModel.filteredMovies
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: MovieCell.identifier, cellType: MovieCell.self)) { row, movie, cell in
                cell.configure(with: movie)
            }
            .disposed(by: disposeBag)
    }
}
