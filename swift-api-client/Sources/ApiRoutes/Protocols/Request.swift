import Alamofire
import Foundation

public enum RequestType {
    public struct UploadFormData {
        public var data: Data
        public var name: String
        public var fileName: String?
        public var mimeType: String?
        public var additionalFields: [String: String] = [:]
    }
    public enum RequestUploadType {
        case multipart([UploadFormData])
    }
    case plain(Alamofire.HTTPMethod)
    case upload(RequestUploadType)
}

/// Defines the general layout of a request. Any request conforms to `Request` protocol
/// can set its properties and then the request itself can be executed via the API client
public protocol Request {
    /// Request endpoint path component
    ///
    /// Provide only the relative path here.
    /// Do not include a `/` the beginning of the relative path
    /// eg `user/getProfile`
    var path: String { get }

    /// HTTP method
    var method: RequestType { get }

    /// Request headers
    ///
    /// The default headers are already set by `Alamofire` on the
    /// `URLSession` level. The headers that are returned here are
    /// only appended to the request that thet belong to
    var headers: [String: String] { get }

    /// Endpoint is auth protected
    var isAuthenticated: Bool { get }

    /// Additional request parameters
    ///
    /// For **GET** requests these are added as URL queries whereas
    /// for **POST** requests they are added to the request's body
    var parameters: [String: Any] { get }
}

/// Default values
public extension Request {
    var parameters: [String: Any] { [:] }
    var headers: [String: String] { [:] }
    var isAuthenticated: Bool { false }
}
