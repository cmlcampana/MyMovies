import SwiftUI

struct MoviePoster: View {
    let posterUrl: String
    let score: Int

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: "\(AppData.shared.posterBaseURL)\(posterUrl)")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Color.red // Indicates an error.
                } else {
                    Color.blue // Acts as a placeholder.
                }
            }
            .frame(width: 150, height: 220)
            .clipped()
            .cornerRadius(10)
            ScoreCircle(score: score)
                .offset(x: 10, y: 15)
        }
    }
}

struct MoviePoster_Previews: PreviewProvider {
    static var previews: some View {
        MoviePoster(
            posterUrl: "/hq2igFqb31fDqGotz8ZuUfwKgn8.jpg",
            score: 75
        )
    }
}
