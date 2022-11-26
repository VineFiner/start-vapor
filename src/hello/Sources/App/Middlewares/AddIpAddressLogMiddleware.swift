//
//  File.swift
//  
//
//  Created by Finer  Vine on 2023/1/2.
//

import Foundation
import Vapor

struct AddIpAddressLogMiddleware: AsyncMiddleware {
    let errorlogLevel: Logger.Level
    let normalLogLevel: Logger.Level
    
    init(errorlogLevel: Logger.Level = .notice, normalLogLevel: Logger.Level = .info) {
        self.errorlogLevel = errorlogLevel
        self.normalLogLevel = normalLogLevel
    }
    
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {

        do {
            let response = try await next.respond(to: request)
            request.logger.log(level: self.normalLogLevel, "\(response.status) \(request.peerAddress?.ipAddress ?? "N/A") \(request.method) \(request.url.path.removingPercentEncoding ?? request.url.path)")
            return response
        } catch let abort as AbortError {
            // 这里只处理 abort 错误
            request.logger.log(level: self.errorlogLevel, "\(abort.status) \(request.peerAddress?.ipAddress ?? "N/A") \(request.method) \(request.url.path.removingPercentEncoding ?? request.url.path)")
            throw abort
        }
    }
}
