import Foundation

/// This is where additional parameters for routes can be set
extension Router.Route {
    /// Configure the request parameters for each endpoint here
    public var parameters: [String : Any] {
        switch self {
        case .module1(let routes):
            switch routes {
            case .module11:
                return [:]
            case .module12:
                return [:]
            }
            
        case .module2(let routes):
            switch routes {
            case let .module21(par1, par2):
                return [
                    "par1": par1,
                    "par2": par2
                ]
            case .module22:
                return [:]
            }
            
        case .module3(let routes):
            switch routes {
            case .module31:
                return [
                    "par": "any param"
                ]
            case .module32:
                return [:]
            }
        }
    }
}
