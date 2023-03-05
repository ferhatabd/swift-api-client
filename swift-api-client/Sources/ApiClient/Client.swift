import ApiRoutes
import SharedModels
import Foundation

extension Data {
    var utf8String: String? {
        String(data: self, encoding: .utf8)
    }
}

/// API Client interface
public struct ApiClient {
    
    // MARK: - Initialization
    public init(
        apiRequest: @escaping @Sendable (Router.Route) async throws -> (Data, URLResponse?)
    ) {
        self.apiRequest = apiRequest
    }

    // MARK: - Public Interface

    // MARK: Properties

    /// General purpose API request handler
    public var apiRequest: @Sendable (Router.Route) async throws -> (Data, URLResponse?)

    // MARK: Methods

    /// Handles the passed api request by making use of the
    /// default `apiRequest` handler passed during initialization
    /// - Parameters:
    ///   - route: Route to be executed
    ///   - file: Caller site file
    ///   - line: Caller site file line number
    /// - Returns: Tuple containing the data and the response from the server
    /// - Throws: `ApiError`
    @discardableResult
    public func apiRequest(
        route: Router.Route,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> (Data, URLResponse?) {
        do {
            let (data, response) = try await self.apiRequest(route)
            #if DEBUG
            print("API: route: \(route), \nStatus: \((response as? HTTPURLResponse)?.statusCode ?? 0), \nReceived data: \(String(decoding: data, as: UTF8.self))")
            #endif
            return (data, response)
        } catch let error as AppError {
            throw error
        } catch {
            throw AppError(error: error, file: file, line: line)
        }
    }

    /// Executes the request making use of the
    /// default `apiRequest` handler. Instead of returning
    /// the `Data` it tries to decode the data into a given object
    /// and returns that instead
    /// - Parameters:
    ///   - route: Route to be executed
    ///   - as: Object type
    ///   - file: Caller site file
    ///   - line: Caller site file line number
    /// - Returns: Tuple containing the data and the response from the server
    /// - Throws: `ApiError`
    public func apiRequest<T: Decodable>(
        route: ApiRoutes.Router.Route,
        as: T.Type,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> T {
        let (data, _) = try await self.apiRequest(route: route, file: file, line: line)
        do {
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            throw AppError(error: error, file: file, line: line)
        }
    }

    // MARK: - Private Interface

    // MARK: Properties

    // MARK: Private methods
}
