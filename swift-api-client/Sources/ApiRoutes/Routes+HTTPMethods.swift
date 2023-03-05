import Foundation

/// The method types for each endpoint can be configured and parameterized here
extension Router.Route {
    public var method: RequestType {
        switch self {
        /// `module1` routes
        case .module1(let routes):
            switch routes {
            case .module11:
                return .plain(.get)
            case .module12:
                return .plain(.post)
            }
            
        /// `module2` routes
        case .module2(let routes):
            switch routes {
            case .module21:
                return .plain(.post)
            case .module22:
                return .plain(.get)
            }
            
        /// `module3` routes
        case .module3(let routes):
            switch routes {
            case .module31:
                return .plain(.post)
            case let .module32(photoModels):
                var formData: [RequestType.UploadFormData] = []
                for model in photoModels {
                    let type = ["value" : model.type]
                    guard let typeData = try? JSONEncoder().encode(type) else { continue }
                    let photoForm: RequestType.UploadFormData = .init(
                        data: model.imageData,
                        name: "photo",
                        fileName: model.fileName,
                        mimeType: "image/jpeg"
                    )
                    formData.append(photoForm)
                    formData.append(.init(data: typeData, name: "type"))
                }
                return .upload(.multipart(formData))
            }
        }
    }
}
