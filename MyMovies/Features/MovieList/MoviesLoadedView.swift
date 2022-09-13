import SwiftUI

struct MoviesLoadedView: View {
    @State private var movieDetail: MovieData?
    let movies: [MovieData]

    var body: some View {
        ScrollView(.vertical) {
            ForEach(movies, id: \.self) { movie in
                MovieView(
                    title: movie.title,
                    posterUrl: movie.posterPath,
                    score: Int(movie.rating * 10),
                    date: DateHelper.shared.convertDateToString(date: movie.releaseDate),
                    action: {
                        movieDetail = movie
                    }
                )
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .sheet(item: $movieDetail, content: { item in
                        SheetView(title: item.title) {
                            MovieDetailView(
                                title: item.title,
                                backdropPath: item.backdropPath,
                                overview: item.overview
                            )
                        }.background(
                            LinearGradient(
                                gradient: Gradient(colors: [.strongBlue, .lightBlue, .shadowBlue]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    })
            }
        }.padding()
    }
}

struct MoviesLoadedView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesLoadedView(movies: [])
    }
}
