import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @State private var movieDetail: MovieData?

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                LoadingView()
            case .loaded:
                moviesLoaded
            case .error:
                errorView
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.strongBlue, .lightBlue, .shadowBlue]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.didAppear()
        }
    }

    private var moviesLoaded: some View {
        ScrollView(.vertical) {
            ForEach(viewModel.movies, id: \.self) { movie in
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

    private var errorView: some View {
        VStack {
            Text("Erro")
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
