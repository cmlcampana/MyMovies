import Foundation

struct Movie: Codable {
    let id: Int
    let posterPath: String?
    let title: String
    let releaseDate: String?
    let rating: Double
    let overview: String
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case releaseDate = "release_date"
        case rating = "vote_average"
        case overview
        case backdropPath = "backdrop_path"
    }
}

struct MovieList: Codable {
    let page: Int
    let numberOfResults: Int
    let numberOfPages: Int
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case numberOfResults = "total_results"
        case numberOfPages = "total_pages"
        case movies = "results"
    }
}
