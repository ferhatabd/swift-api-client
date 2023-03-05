import Foundation

/// Error definitions
public enum ApiError: Error {
    case invalidURL
    case noData
    case tokenNotSet
    case afError(Error)
    case serverError(statusCode: Int, message: String?)
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        var description = "APIError: "
        switch self {
        case .invalidURL:
            description += "Invalid url"
        case .noData:
            description += "No Data"
        case .tokenNotSet:
            description += "Token not set"
        case .afError(let error):
            description += "AFError with description - " + error.localizedDescription
        case .serverError(statusCode: let statusCode, message: let message):
            description += "Server Error \nStatus Code: \(statusCode),\n\(String(describing: message))"
        }
        return description
    }
}
