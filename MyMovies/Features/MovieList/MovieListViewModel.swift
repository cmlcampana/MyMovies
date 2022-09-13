import SwiftUI

enum MovieState {
    case loading
    case loaded
    case error
}

final class MovieListViewModel: ObservableObject {
    private let repository: MovieListRepositoryProtocol
    private let movieType: MovieType

    @Published private(set) var movies: [MovieData] = []
    @Published private(set) var state: MovieState = .loading

    init(
        repository: MovieListRepositoryProtocol = MovieListRepository(),
        movieType: MovieType = .popular
    ) {
        self.repository = repository
        self.movieType = movieType
    }

    func didAppear() {
        state = .loading
        Task.init {
            let result = await repository.getMovieList(
                movieType: .upcoming,
                page: 1,
                language: .ptBR
            )

            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.movies = self.convertToMovieData(list.movies)
                    self.state = .loaded
                case .failure:
                    self.state = .error
                    print("ERRO")
                }
            }
        }
    }

    private func convertToMovieData(_ movieList: [Movie]) -> [MovieData] {
        movieList.map {
            MovieData(movie: $0)
        }.sorted(by: {
            $0.releaseDate?.compare($1.releaseDate ?? Date()) == .orderedDescending
        })
    }
}
