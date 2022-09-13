import SwiftUI

struct MovieDetailView: View {
    let title: String
    let backdropPath: String
    let overview: String

    @State private var isPresented: Bool = false

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "\(AppData.shared.posterBaseURL)\(backdropPath)")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .foregroundColor(.lightGray)
                        .frame(width: 80, height: 80)
                } else {
                    LottieView(name: "loading", loopMode: .loop)
                        .frame(width: 150, height: 150)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 350)
            .clipped()

            ScrollView(.vertical) {
                VStack {
                    Text(overview)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)

                    HStack {
                        Spacer()
                        Button(
                            action: {
                                isPresented = true
                            },
                            label: {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.strongGray)
                                    .frame(width: 24, height: 24)
                            }
                        ).sheet(
                            isPresented: $isPresented,
                            onDismiss: nil,
                            content: {
                                ShareSheet(activityItems: ["\(title) \n \(overview)"])
                            }
                        )
                    }
                    .padding([.top, .trailing], 16)
                }.padding(.horizontal, 16)
            }
        }
        .offset(y: -16)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(
            title: "Bla",
            backdropPath: "",
            overview: "Bla bla"
        )
    }
}
