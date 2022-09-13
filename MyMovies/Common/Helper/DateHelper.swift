import Foundation

struct DateHelper {
    static let shared = DateHelper()

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    private var dateFormatterToString: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }

    func convertStringToDate(dateString: String?) -> Date? {
        if let dateString = dateString {
            return dateFormatter.date(from: dateString)
        } else {
            return nil
        }
    }

    func convertDateToString(date: Date?) -> String {
        if let date = date {
            return dateFormatterToString.string(from: date)
        } else {
            return "-"
        }
    }
}
