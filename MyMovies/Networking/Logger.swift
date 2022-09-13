import Foundation

struct Logger {
    static func log(request: URLRequest) {
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""

        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        let path = "\(urlComponents?.path ?? "")"

        print("\n - - - - - - - - - - \(path) - - - - - - - - - - \n")

        var logOutput = """
                            \(urlAsString) \n\n
                            \(method) \(path)?\(query) HTTP/1.1 \n
                            HOST: \(host)\n
                            """
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }

        print(logOutput)

        print("\n - - - - - - - - - -  FIM - - - - - - - - - - \n")
    }

    static func log(data: Data?, response: URLResponse?) {
        if let data = data,
           let dataOutput = String(data: data, encoding: .utf8),
           let response = response,
           let httpResponse = response as? HTTPURLResponse {
            print("\n - - - - - - - - - - \(response.url?.path ?? "") - - - - - - - - - - \n")
            print(dataOutput, httpResponse.statusCode)
            print("\n - - - - - - - - - -  FIM - - - - - - - - - - \n")
        }
    }
}
