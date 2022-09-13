import Foundation

struct AppData {
    static let shared = AppData()

    var baseURL: String {
        "https://api.themoviedb.org"
    }
    var apiKey: String {
        "365c0b8384162b60d9fb7ebf8dd0ae4c"
    }

    var posterBaseURL: String {
        "https://image.tmdb.org/t/p/original/"
    }

    var backdropBaseURL: String {
        "http://image.tmdb.org/t/p/w500"
    }
}

enum Language: String, Equatable {
    case enUS = "en-US"
    case ptBR = "pt-BR"
}
