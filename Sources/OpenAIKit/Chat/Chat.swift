import Foundation

/**
 Given a prompt, the model will return one or more predicted chat comppublic letions, and can also return the probabilities of alternative tokens at each position.
 */
public struct Chat: Codable {
    public let id, object: String
    public let created: Int
    public let model: String
    public let choices: [Choice]
    public let usage: Usage
}

// MARK: - Choice
public struct Choice: Codable {
    public let index: Int
    public let message: ChatMessage
    public let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

public enum Role: String, Codable {
    case system
    case assistant
    case user
    case function
}

// MARK: - Message
public struct ChatMessage: Codable {
    public let role: Role
    public let content: String
    public let functionCall: FunctionCall?
    
    public init(role: Role, content: String) {
        self.role = role
        self.content = content
        self.functionCall = nil
    }

    enum CodingKeys: String, CodingKey {
        case role, content
        case functionCall = "function_call"
    }
}

// MARK: - FunctionCall
public struct FunctionCall: Codable {
    public let name, arguments: String
}
