import Alamofire
import Foundation

final class AlamofireLogger: EventMonitor {
    func requestDidResume(_ request: Alamofire.Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️ Request Started: \(request)
        ⚡️ Body Data: \(body)
        """
        NSLog(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        NSLog("⚡️ Response Received: \(response.debugDescription)")
    }
}
