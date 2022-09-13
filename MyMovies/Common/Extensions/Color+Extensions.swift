import SwiftUI

extension Color {
    static var strongGray: Color {
        Color(red: 153, green: 153, blue: 153)
    }

    static var lightGray: Color {
        Color(red: 242, green: 242, blue: 242)
    }

    static var strongBlue: Color {
        Color(red: 0, green: 153, blue: 204)
    }

    static var lightBlue: Color {
        Color(red: 51, green: 204, blue: 255)
    }

    static var shadowBlue: Color {
        Color(red: 230, green: 249, blue: 255)
    }

    init(red: Double, green: Double, blue: Double) {
        self.init(.sRGB, red: red / 255, green: green / 255, blue: blue / 255, opacity: 1)
    }
}
