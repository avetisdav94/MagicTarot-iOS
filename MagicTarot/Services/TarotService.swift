import Foundation

// Ошибки, которые могут возникнуть
enum TarotServiceError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class TarotService {
    
    // Используем модель Flash (она быстрая и дешевая)

    private let modelName = "gemini-2.5-flash"
    
    func getPrediction(for cardName: String, isReversed: Bool = false) async throws -> String {
        
        // 1. Формируем URL
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/\(modelName):generateContent?key=\(Secrets.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw TarotServiceError.invalidURL
        }
        
        // 2. Определяем язык пользователя
        let language = Locale.current.identifier // вернет "pl_PL", "en_US" и т.д.
        let langName = Locale.current.localizedString(forIdentifier: language) ?? "English"
        
        // 3. Промпт (Самая важная часть!)
        // Мы говорим AI, кто он такой и что должен сделать.
        let cardState = isReversed ? "(в перевернутом положении)" : "(w pozycji prostej)"
        
        let prompt = """
        Wciel się w rolę mistycznej Wiedźmy Weroniki. Jesteś mądrą, empatyczną i tajemniczą przewodniczką duchową.
        
        Użytkownik wylosował kartę Tarota: "\(cardName)" \(cardState).
        
        Twoje zadanie:
        1. Zinterpretuj tę kartę krótko i mistycznie na dzisiejszy dzień.
        2. Daj jedną konkretną radę.
        3. Odpowiedz w języku: \(langName).
        4. Używaj formatowania Markdown (pogrubienia **tekst**, nagłówki ##).
        5. Nie pisz "Witaj", przejdź od razu do interpretacji.
        
        Bądź tajemnicza, ale wspierająca.
        """
        
        // 4. Собираем Request
        let part = GeminiPart(text: prompt)
        let content = GeminiContent(role: "user", parts: [part])
        
        // Настройка креативности (0.7 - хороший баланс для магии)
        let config = GenerationConfig(temperature: 0.8, maxOutputTokens: 500)
        
        let requestBody = GeminiRequest(contents: [content], generationConfig: config)
        
        // 5. Настройка сетевого запроса
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        // 6. Отправляем в космос 🚀
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Проверка статуса
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Gemini API Error: \(errorMsg)")
            throw TarotServiceError.serverError("Status: \(httpResponse.statusCode)")
        }
        
        // 7. Декодируем ответ
        do {
            let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
            
            if let text = geminiResponse.candidates?.first?.content?.parts.first?.text {
                return text
            } else {
                throw TarotServiceError.noData
            }
        } catch {
            print("Decoding Error: \(error)")
            throw TarotServiceError.decodingError
        }
    }
}
