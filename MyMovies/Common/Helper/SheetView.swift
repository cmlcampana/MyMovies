import SwiftUI

struct SheetView<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.lightBlue)

            Text(title)
                .font(.system(size: 16).bold())
                .foregroundColor(.lightGray)

            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.lightGray)
                }
            }.padding(.horizontal, 24)
        }.frame(height: 60)

        content

        Spacer()
    }
}
