import Foundation

public struct UploadPhotoModel: Codable, Hashable, Sendable {
    public var imageData: Data
    public let type: String
    public let fieldname: String
    public let encoding: String
    /// Image file name
    /// - Note: Image filenames are always prefixed by a `UUID`. The file name passed
    /// within the initializer will be appended to the end
    public let fileName: String
    public init(imageData: Data, type: String, fieldname: String, encoding: String) {
        self.imageData = imageData
        self.type = type
        self.fieldname = fieldname
        self.encoding = encoding
        self.fileName = UUID().uuidString + "-" + "photo"
    }
}
