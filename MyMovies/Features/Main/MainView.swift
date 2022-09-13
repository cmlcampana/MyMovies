import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                createTab(with: "Populares").tag(0)
                createTab(with: "Melhores avaliados").tag(1)
                createTab(with: "Em cartaz").tag(2)
                createTab(with: "Em breve").tag(3)
            }
            .pickerStyle(.segmented)
            .fixedSize(horizontal: false, vertical: true)
            .background(Color.shadowBlue)
        }
    }

    private func createTab(with text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.center)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
