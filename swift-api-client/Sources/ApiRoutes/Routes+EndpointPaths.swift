import Foundation
import SharedModels

/// This is where the relative path for each endpoint must be configured
extension Router.Route {
    public var path: String {
        switch self {
        case .module1(let route):
            let path = "module1"
            switch route {
            case .module11:
                return [path, "getModule11"].joined(separator: "/")
            case .module12:
                return [path, "postModule12"].joined(separator: "/")
            }
        case .module2(let route):
            let path = "module2"
            switch route {
            case .module21:
                return [path, "postModule21"].joined(separator: "/")
            case .module22:
                return [path, "getModule22"].joined(separator: "/")
            }
        case .module3(let route):
            let path = "module3"
            switch route {
            case .module31:
                return [path, "postModule31"].joined(separator: "/")
            case .module32:
                return [path, "uploadMultipart32"].joined(separator: "/")
            }
        }
    }
}
