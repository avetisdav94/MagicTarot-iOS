import Foundation

// MARK: - Request (То, что отправляем)
struct GeminiRequest: Codable {
    let contents: [GeminiContent]
    let generationConfig: GenerationConfig?
}

struct GeminiContent: Codable {
    let role: String // "user" или "model"
    let parts: [GeminiPart]
}

struct GeminiPart: Codable {
    let text: String
}

struct GenerationConfig: Codable {
    let temperature: Double // Креативность (0.0 - робот, 1.0 - фантазер)
    let maxOutputTokens: Int // Длина ответа
}

// MARK: - Response (То, что получаем)
struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]?
}

struct GeminiCandidate: Codable {
    let content: GeminiContent?
    let finishReason: String?
}
