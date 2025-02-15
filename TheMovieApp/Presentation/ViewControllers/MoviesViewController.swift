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

        // ✅ Detectar selección de celda y navegar a la vista de detalle
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                let detailViewModel = MovieDetailViewModel(movieID: movie.id)
                let detailVC = MovieDetailViewController(viewModel: detailViewModel)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// ✅ Extensión para manejar el scroll infinito y cargar más películas
extension MoviesViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // ✅ Detecta cuando el usuario llega al final y hace un scroll adicional
        if offsetY > contentHeight - frameHeight + 50 { // Se activa al hacer un extra scroll
            viewModel.fetchMoreMovies() // Llama a la función en el ViewModel
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = try? viewModel.allMovies.value()[indexPath.row] // Obtiene la película seleccionada
        guard let selectedMovie = movie else { return }

        let detailViewModel = MovieDetailViewModel(movieID: selectedMovie.id)
        let detailVC = MovieDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// ✅ Extensión para manejar el estado de "Visto"
extension MoviesViewController: MovieCellDelegate {
    func didTapWatched(for movie: Movie) {
        guard let index = try? viewModel.allMovies.value().firstIndex(where: { $0.id == movie.id }) else { return }

        viewModel.toggleWatchedState(for: index)

        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

