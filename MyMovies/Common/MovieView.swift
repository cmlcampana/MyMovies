import SwiftUI

struct MovieView: View {
    let title: String
    let posterUrl: String
    let score: Int
    let date: String
    let action: () -> Void

    var body: some View {
        HStack {
            MoviePoster(posterUrl: posterUrl, score: score)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 12))
                    .bold()
                    .padding(.bottom)

                Text(date)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .onTapGesture {
            action()
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(
            title: "Doutor Estranho no Multiverso da Loucura",
            posterUrl: "/hq2igFqb31fDqGotz8ZuUfwKgn8.jpg",
            score: 75,
            date: "2022-05-05",
            action: {}
        )
    }
}
