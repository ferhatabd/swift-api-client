import Alamofire
import ApiClient
import ApiRoutes
import Dependencies
import Foundation
import SharedModels

// Live dependency configuration
extension ApiClient: DependencyKey {
    public static var liveBaseURL = URL(string: "https://httpbin.org")!
    public static var liveValue: ApiClient = .live(
        baseURL: liveBaseURL,
        setToken: { nil }
    )

    /// Configures the live dependency
    /// - Parameter baseURL: Base URL to be used for the router
    /// - Parameter setToken: Closure that optionally returns an API token.
    /// If no closure is passed here, the token is retrieved from the default
    /// `CLUser` instance (which is the current user)
    ///
    /// - Returns: An `ApiClient` instance to be used
    public static func live(
        baseURL: URL = ApiClient.liveBaseURL,
        setToken: @escaping () async throws -> Router.Token?
    ) -> Self {
        
        /// Underlying actor that handles the requests in a concurrency safe way
        actor Session {
            private let router: Router
            private let baseURL: URL
            private let token: () async throws -> Router.Token?
            init(baseURL: URL, token: @escaping () async throws -> Router.Token?) {
                self.baseURL = baseURL
                self.token = token
                self.router = Router(baseURL: baseURL, token: token)
            }

            func apiRequest(route: Router.Route) async throws -> (Data, URLResponse?) {
                let request = try await router.request(for: route)
                let task = request.serializingData(automaticallyCancelling: true)
                let response = await task.response
                if let error = response.error {
                    throw AppError(error: ApiError.afError(error))
                }
                
                let successRange = 200..<300
                // Check if api returned a success code, if not throw error.
                if let statusCode = response.response?.statusCode, !successRange.contains(statusCode) {
                    let dataDictionary = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: Any]
                    let errorMessage = dataDictionary?["message"] as? String
                    throw AppError(error: ApiError.serverError(statusCode: statusCode, message: errorMessage))
                }

                guard let data = response.data else {
                    throw AppError(error: ApiError.noData)
                }
                
                return (data, response.response)
            }
        }

        let session = Session(
            baseURL: baseURL,
            token: setToken
        )
        return Self(apiRequest: { route in try await session.apiRequest(route: route) })
    }
    
    public func setTokenProvider(_ provider: @escaping @Sendable () async throws -> Router.Token?) {
        ApiClient.liveValue = .live(
            setToken: provider
        )
    }
}
