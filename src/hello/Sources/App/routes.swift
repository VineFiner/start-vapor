import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req async throws -> View in
        let ip: String = req.peerAddress?.ipAddress ?? "Vapor"
        return try await req.view.render("index", ["title": "Hello \(ip)"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: TodoController())
}
