import Foundation

extension AppError: Equatable {
    public static func == (lhs: AppError, rhs: AppError) -> Bool {
        lhs.errorDump == rhs.errorDump &&
        lhs.file == rhs.file &&
        lhs.line == rhs.line &&
        lhs.message == rhs.message &&
        lhs.statusCode == rhs.statusCode &&
        lhs.errorDescription == rhs.errorDescription
    }
}

public struct AppError: Error {
    public let error: Error // Contains the actual error.
    public let errorDump: String
    public let file: String
    public let line: UInt
    
    public init(
        error: Error,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        self.error = error
        var string = ""
        dump(error, to: &string)
        self.errorDump = string
        self.file = String(describing: file)
        self.line = line
    }

    public var statusCode: Int? {
        if case .serverError(statusCode: let statusCode, message: _) = (error as? ApiError) {
            return statusCode
        }
        return nil
    }
    
    /// This is the only available if the api sent `"message"` field as an error
    public var message: String? {
        if case .serverError(statusCode: _, message: let message) = (error as? ApiError) {
            return message
        }
        return nil
    }
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        error.localizedDescription
    }
}
