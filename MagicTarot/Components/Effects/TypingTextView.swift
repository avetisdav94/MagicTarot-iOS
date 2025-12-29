import SwiftUI

struct TypingTextView: View {
    // Входящие параметры
    let fullText: String
    let typingSpeed: UInt64 // Храним сразу в наносекундах для Task.sleep
    var onComplete: (() -> Void)?
    
    // Состояние
    @State private var displayedText: String = ""
    @State private var isSkipped = false // Флаг, если пользователь нажал "пропустить"
    
    // Инициализатор
    init(_ text: String, speed: Double = 0.03, onComplete: (() -> Void)? = nil) {
        self.fullText = text
        // Конвертируем секунды (0.03) в наносекунды для процессора
        self.typingSpeed = UInt64(speed * 1_000_000_000)
        self.onComplete = onComplete
    }
    
    var body: some View {
        Text(displayedText)
            .font(AppFont.body()) // Используем твой шрифт
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
            // .task — это современная замена .onAppear для асинхронных задач.
            // id: fullText означает "если текст изменится, перезапусти печатание заново"
            .task(id: fullText) {
                await typeText()
            }
            .onTapGesture {
                skipToEnd()
            }
    }
    
    // Асинхронная функция печати
    @MainActor // Гарантирует, что обновление текста происходит в главном потоке (без лагов UI)
    private func typeText() async {
        // 1. Сброс перед началом
        displayedText = ""
        isSkipped = false
        
        // 2. Превращаем строку в массив символов (это работает в 100 раз быстрее, чем работа с индексами String)
        let characters = Array(fullText)
        
        // 3. Цикл по буквам
        for char in characters {
            // Если пользователь нажал "пропустить", выходим из цикла
            if isSkipped { return }
            
            // Ждем (пауза между буквами)
            // try? означает: "если задача отменена (экран закрыт), просто прекрати, не крашься"
            try? await Task.sleep(nanoseconds: typingSpeed)
            
            // Добавляем букву
            if !isSkipped {
                displayedText.append(char)
            }
        }
        
        // 4. Завершение
        onComplete?()
    }
    
    // Функция пропуска анимации
    private func skipToEnd() {
        isSkipped = true // Останавливаем цикл
        displayedText = fullText // Показываем сразу весь текст
        onComplete?() // Сообщаем, что готово
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        TypingTextView(
            "Wiedźma Weronika widzi twoją przyszłość... Karty układają się w pomyślny znak.",
            speed: 0.05
        )
        .padding()
    }
}
