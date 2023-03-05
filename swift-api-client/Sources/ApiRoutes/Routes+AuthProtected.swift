import Foundation

/// Configure the authentication status for each endpoint here
extension Router.Route {
    public var isAuthenticated: Bool {
        switch self {
        case .module1,
            .module2:
            return true
            
        case .module3:
            return false
        }
    }
}
