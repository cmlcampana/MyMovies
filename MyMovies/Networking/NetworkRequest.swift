import Foundation

enum NetworkError: Error {
    case genericError
    case notFound
    case offline
    case unauthorized
    case badRequest
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

struct NetworkRequest {
    let baseURL: URL
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let queryParameters: [String: AnyEncodable]?
    let bodyParameters: [String: AnyEncodable]?

    static func buildGetRequest(
        path: String,
        headers: [String: String]? = nil,
        params: [String: AnyEncodable]
    ) -> NetworkRequest {
        buildRequest(path: path, method: .get, parameters: params)
    }

    private static func buildRequest(
        path: String,
        method: HTTPMethod,
        parameters: [String: AnyEncodable]? = nil
    ) -> NetworkRequest {
        NetworkRequest(
            baseURL: URL(string: AppData.shared.baseURL)!,
            path: path,
            method: method,
            headers: nil,
            queryParameters: (method == .get || method == .delete) ? parameters : nil,
            bodyParameters: (method == .get || method == .delete) ? nil : parameters
        )
    }
}
