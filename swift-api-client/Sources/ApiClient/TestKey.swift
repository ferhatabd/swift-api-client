import Dependencies
import Foundation
import XCTestDynamicOverlay
import ApiRoutes

public extension DependencyValues {
var apiClient: ApiClient {
    get { self[ApiClient.self] }
    set { self[ApiClient.self] = newValue }
  }
}

extension ApiClient: TestDependencyKey {
    public static var testValue = Self(apiRequest: XCTUnimplemented("\(Self.self).apiRequest"))
    public static var previewValue = Self.noop
    
    public func setTokenProvider(_ provider: (@Sendable () async throws -> Router.Token?)? = nil) {   }
}

public extension ApiClient {
    static var noop: ApiClient {
        .init(apiRequest: { _ in try await Task.never() })
    }
}

extension Task where Failure == Never {
    /// An async function that never returns.
    static func never() async throws -> Success {
        for await element in AsyncStream<Success>.never {
            return element
        }
        throw _Concurrency.CancellationError()
    }
}
extension AsyncStream {
    static var never: Self {
        Self { _ in }
    }
}
