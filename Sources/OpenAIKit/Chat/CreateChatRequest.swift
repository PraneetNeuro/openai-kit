import AsyncHTTPClient
import NIOHTTP1
import Foundation
import AnyCodable

struct CreateChatRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/v1/chat/completions"
    let body: Data?
    
    init(
        model: String,
        messages: [ChatMessage],
        functions: [[String: AnyEncodable]],
        functionCall: String,
        temperature: Double,
        topP: Double,
        n: Int,
        stream: Bool,
        stops: [String],
        maxTokens: Int?,
        presencePenalty: Double,
        frequencyPenalty: Double,
        logitBias: [String: Int],
        user: String?
    ) throws {
        
        var body = Body(
            model: model,
            messages: messages,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: stream,
            stops: stops,
            maxTokens: maxTokens,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            logitBias: logitBias,
            user: user
        )
        
        if !functions.isEmpty && String(model.split(separator: "-").last!) == "0613" {
            body.functions = functions
            body.functionCall = functionCall
        }
                
        self.body = try Self.encoder.encode(body)
    }
}

extension CreateChatRequest {
    struct Body: Encodable {
        let model: String
        let messages: [ChatMessage]
        var functions: [[String: AnyEncodable]]?
        var functionCall: String?
        let temperature: Double
        let topP: Double
        let n: Int
        let stream: Bool
        let stops: [String]
        let maxTokens: Int?
        let presencePenalty: Double
        let frequencyPenalty: Double
        let logitBias: [String: Int]
        let user: String?
        
        init(model: String, messages: [ChatMessage], temperature: Double, topP: Double, n: Int, stream: Bool, stops: [String], maxTokens: Int?, presencePenalty: Double, frequencyPenalty: Double, logitBias: [String : Int], user: String?) {
            self.model = model
            self.messages = messages
            self.temperature = temperature
            self.topP = topP
            self.n = n
            self.stream = stream
            self.stops = stops
            self.maxTokens = maxTokens
            self.presencePenalty = presencePenalty
            self.frequencyPenalty = frequencyPenalty
            self.logitBias = logitBias
            self.user = user
        }
            
        enum CodingKeys: CodingKey {
            case model
            case messages
            case functions
            case functionCall
            case temperature
            case topP
            case n
            case stream
            case stop
            case maxTokens
            case presencePenalty
            case frequencyPenalty
            case logitBias
            case user
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(model, forKey: .model)
            
            if !messages.isEmpty {
                try container.encode(messages, forKey: .messages)
            }
            
            if !(functions?.isEmpty ?? true) && String(model.split(separator: "-").last!) == "0613" {
                try container.encodeIfPresent(functions, forKey: .functions)
                try container.encode(functionCall, forKey: .functionCall)
            }

            try container.encode(temperature, forKey: .temperature)
            try container.encode(topP, forKey: .topP)
            try container.encode(n, forKey: .n)
            try container.encode(stream, forKey: .stream)
            
            if !stops.isEmpty {
                try container.encode(stops, forKey: .stop)
            }
            
            if let maxTokens {
                try container.encode(maxTokens, forKey: .maxTokens)
            }
            
            try container.encode(presencePenalty, forKey: .presencePenalty)
            try container.encode(frequencyPenalty, forKey: .frequencyPenalty)
            
            if !logitBias.isEmpty {
                try container.encode(logitBias, forKey: .logitBias)
            }
            
            try container.encodeIfPresent(user, forKey: .user)
        }
    }
}
