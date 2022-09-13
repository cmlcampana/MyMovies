import Foundation

protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: [String: AnyEncodable]) throws
}

struct AnyEncodable: Encodable, CustomStringConvertible, Equatable {
    var description: String {
        self.encodable as? String ?? ""
    }

    private let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try self.encodable.encode(to: encoder)
    }

    static func == (lhs: AnyEncodable, rhs: AnyEncodable) -> Bool {
        lhs.description == rhs.description
    }
}

struct JSONParameterEncoder: ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: [String: AnyEncodable]) throws {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let jsonAsData = try jsonEncoder.encode(parameters)
            urlRequest.httpBody = jsonAsData

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.genericError
        }
    }
}

struct URLParameterEncoder: ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: [String: AnyEncodable]) {
        guard let url = urlRequest.url, !parameters.isEmpty else { return }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(
                    name: key,
                    value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                )
                urlComponents.queryItems?.append(queryItem)
            }

            urlRequest.url = urlComponents.url
        }
    }
}

enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding

    func encode(
        urlRequest: inout URLRequest,
        bodyParameters: [String: AnyEncodable]?,
        urlParameters: [String: AnyEncodable]?
    ) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                      let urlParameters = urlParameters else { return }
                URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            }
        } catch {
            throw error
        }
    }
}
