import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func request<T: Codable>(_ route: NetworkRequest) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    private var task: URLSessionTask?

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request<T: Codable>(_ route: NetworkRequest) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            request(route) { result in
                continuation.resume(with: result)
            }
        }
    }

    // MARK: - Private methods

    fileprivate func request<T: Codable>(_ route: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let request = try buildRequest(from: route)
            Logger.log(request: request)

            task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                DispatchQueue.main.async {
                    guard self != nil else {
                        return completion(.failure(.genericError))
                    }

                    Logger.log(data: data, response: response)

                    if let error = error {
                        let networkError: NetworkError = (error as? URLError)?.code == .notConnectedToInternet ? .offline : .genericError
                        return completion(.failure(networkError))
                    }

                    let httpResponse = response as? HTTPURLResponse
                    if let data = data, let statusCode = httpResponse?.statusCode {
                        switch statusCode {
                        case 200...209:
                            do {
                                let decoded = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(decoded))
                            } catch {
                                #if DEBUG
                                print(error)
                                #endif
                                completion(.failure(.genericError))
                            }

                        case 400...499:
                            completion(.failure(.unauthorized))
                        case 500...599:
                            completion(.failure(.badRequest))
                        default:
                            completion(.failure(.genericError))
                        }
                    }
                }
            })
        } catch {
            completion(.failure(.genericError))
        }

        task?.resume()
    }

    fileprivate func buildRequest(from networkRequest: NetworkRequest) throws -> URLRequest {
        let url = networkRequest.baseURL.appendingPathComponent(networkRequest.path)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0
        )

        if let queryParams = networkRequest.queryParameters {
            URLParameterEncoder().encode(urlRequest: &request, with: queryParams)
        }

        if let bodyParam = networkRequest.bodyParameters {
            try JSONParameterEncoder().encode(urlRequest: &request, with: bodyParam)
        }

        request.httpMethod = networkRequest.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAdditionalHeaders(networkRequest.headers, request: &request)
        return request
    }

    fileprivate func addAdditionalHeaders(_ additionalHeaders: [String: String]?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
