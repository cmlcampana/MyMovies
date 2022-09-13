import Foundation

struct MovieData: Hashable, Equatable, Identifiable {
    let id: Int
    let posterPath: String
    let title: String
    let releaseDate: Date?
    let rating: Double
    let overview: String
    let backdropPath: String

    init(movie: Movie) {
        self.id = movie.id
        self.posterPath = movie.posterPath ?? ""
        self.title = movie.title
        self.overview = movie.overview
        self.backdropPath = movie.backdropPath ?? ""
        self.rating = movie.rating
        self.releaseDate = DateHelper.shared.convertStringToDate(dateString: movie.releaseDate)
    }
}
