import Alamofire
import SharedModels
import Foundation

public struct Router {
    // MARK: - Types
    
    public typealias Token = String

    /// Available routes
    ///
    /// This is the starting point for adding a new route to the client.
    /// When a new case (ie route) is added here the compiler will complain as
    /// the conformance to `Request` protocol is broken at that point.
    ///
    ///
    /// Conformance to `Request` is broken into
    /// separate files to avoid heavy scrolling while adding a new
    /// route. The necessary files are:
    /// - `Routes+RequestParameters` -> Configure request bodies or URL queries
    /// - `Routes+EndpointPaths` -> Configure the relative paths of each point with respect to the base URL
    /// - `Routes+HTTPMethods` -> Configure the HTTP method for each request
    /// - `Routes+AuthProtected` -> Configure if an endpoint is protected behind an auth mechanism
    ///
    public enum Route: Equatable, Sendable, Request { 
        /// Routes for app modules are defined here
        case module1(Module1Routes)
        case module2(Module2Routes)
        case module3(Module3Routes)
        
        public enum Module1Routes: Equatable, Sendable {
            case module11
            case module12
        }
        
        public enum Module2Routes: Equatable, Sendable {
            case module21(parameter1: String, parameter2: Int)
            case module22
        }
        
        public enum Module3Routes: Equatable, Sendable {
            case module31
            case module32([UploadPhotoModel])
        }

    }

    // MARK: - Initialization
    /// Initializes the router with the base URL to be used
    /// - Parameter baseURL: Base URL
    /// - Parameter token: API token
    public init(
        baseURL: URL,
        token: @escaping () async throws -> Token?
    ) {
        self.baseURL = baseURL
        self.token = token
//        self.afSession = .init()
        /* Use the initializer below to log each and every request + response */
        self.afSession = .init(eventMonitors: [AlamofireLogger()])
    }

    // MARK: - Public Interface

    // MARK: Properties

    public let baseURL: URL
    private let token: () async throws -> Token?
    private let afSession: Alamofire.Session

    // MARK: Methods

    /// Generates a `URLRequest` for the given route
    /// - Parameter route: Requested route
    /// - Returns: `URLRequest` to be executed
    public func request(for route: Route) async throws -> DataRequest {
        let url = baseURL.appendingPathComponent(route.path)
        var headers = HTTPHeaders.default
        if !route.headers.isEmpty {
            route.headers.forEach { headers.add(name: $0, value: $1)}
        }
        if route.isAuthenticated {
            guard let token = try await token() else {
                throw ApiError.tokenNotSet
            }
            headers.add(.authorization(bearerToken: token))
        }
        
        switch route.method {
        case .plain(let method):
            let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding(options: [.prettyPrinted, .fragmentsAllowed])
            return afSession.request(
                url,
                method: method,
                parameters: route.parameters,
                encoding: encoding,
                headers: headers
            )
            
        case .upload(.multipart(let formData)):
            return afSession.upload(multipartFormData: { multipart in
                for form in formData {
                    multipart.append(form.data, withName: form.name, fileName: form.fileName, mimeType: form.mimeType)
                    guard !form.additionalFields.isEmpty,
                            let additionalData = try? JSONEncoder().encode(form.additionalFields) else { continue }
                    multipart.append(additionalData, withName: form.name)
                }
            }, to: url, headers: headers)
        }
        
   
    }

    // MARK: - Private Interface

    // MARK: Properties

    // MARK: Private methods
}
