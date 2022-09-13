import Foundation

enum MovieType: String {
    case popular
    case nowPlaying
    case topRated
    case upcoming

    var path: String {
        switch self {
        case .popular:
            return "/3/movie/popular"
        case .nowPlaying:
            return "/3/movie/now_playing"
        case .topRated:
            return "/3/movie/top_rated"
        case .upcoming:
            return "/3/movie/upcoming"
        }
    }
}

protocol MovieListRepositoryProtocol {
    func getMovieList(
        movieType: MovieType,
        page: Int,
        language: Language
    ) async -> (Result<MovieList, NetworkError>)
}

final class MovieListRepository: MovieListRepositoryProtocol {
    private let manager: NetworkManagerProtocol

    init(manager: NetworkManagerProtocol = NetworkManager()) {
        self.manager = manager
    }

    func getMovieList(
        movieType: MovieType,
        page: Int = 1,
        language: Language = .ptBR
    ) async -> (Result<MovieList, NetworkError>) {
        do {
            let request = NetworkRequest.buildGetRequest(
                path: movieType.path,
                params: [
                    "api_key": AnyEncodable(AppData.shared.apiKey),
                    "language": AnyEncodable(language.rawValue),
                    "page": AnyEncodable(page)
                ]
            )

            let result: MovieList = try await manager.request(request)
            return .success(result)
        } catch {
            return .failure(.genericError)
        }
    }
}
