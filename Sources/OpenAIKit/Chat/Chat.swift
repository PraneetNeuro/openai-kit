import Foundation

/**
 Given a prompt, the model will return one or more predicted chat completions, and can also return the probabilities of alternative tokens at each position.
 */
public struct Chat: Codable {
    let id, object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
}

// MARK: - Choice
public struct Choice: Codable {
    let index: Int
    let message: ChatMessage
    let finishReason: String?

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
    let role: Role
    let content: String
    let functionCall: FunctionCall?
    
    init(role: Role, content: String) {
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
    let name, arguments: String
}
