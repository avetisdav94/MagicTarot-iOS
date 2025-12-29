// Components/AI/InterpretationView.swift

import SwiftUI

struct InterpretationView: View {
    let interpretation: String
    var isStreaming: Bool = false
    var onSave: (() -> Void)?
    var onShare: (() -> Void)?
    
    @State private var showFullText = false
    @State private var isTypingFinished = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                
                // MARK: 1. Заголовок
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(Color.theme.goldAccent)
                    
                    // Используем локализацию
                    Text(String(localized: "witch_says")) // "Wiedźma Weronika mówi..."
                        .font(AppFont.headline())
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    // Если идет загрузка (стриминг)
                    if isStreaming {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                }
                
                Divider()
                    .background(Color.theme.glassBorder)
                
                // MARK: 2. Текст интерпретации
                // Ограничиваем высоту, чтобы скролл работал внутри карточки
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        if isStreaming {
                            // Пока ждем ответа — показываем мигающие точки (твой компонент)
                            StreamingTextView(text: .constant("Nawiązywanie połączenia..."), isStreaming: true)
                        } else {
                            // Когда ответ пришел — запускаем печатную машинку!
                            TypingTextView(interpretation, speed: 0.03) {
                                // Когда печать закончилась — показываем кнопки
                                withAnimation {
                                    isTypingFinished = true
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                // Ограничиваем высоту скролла, чтобы карточка не растягивалась бесконечно
                .frame(maxHeight: 300)
                
                // MARK: 3. Кнопки действий
                // Показываем их только когда текст перестал печататься (или если стриминг кончился)
                if !isStreaming && isTypingFinished && !interpretation.isEmpty {
                    Divider()
                        .background(Color.theme.glassBorder)
                        .transition(.opacity)
                    
                    HStack(spacing: AppSpacing.md) {
                        ActionButton(icon: "heart", label: String(localized: "save_button")) {
                            onSave?()
                        }
                        
                        ActionButton(icon: "square.and.arrow.up", label: String(localized: "share_button")) {
                            onShare?()
                        }
                        
                        Spacer()
                        
                        ActionButton(icon: "doc.on.doc", label: String(localized: "copy_button")) {
                            UIPasteboard.general.string = interpretation
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(AppSpacing.md)
            .glassBackground() // Твой модификатор
            // Сбрасываем флаг завершения, если текст поменялся
            .onChange(of: interpretation) { _ in
                isTypingFinished = false
            }
        }
    }

// MARK: - Formatted Text
struct FormattedInterpretationText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        // Разбиваем текст на параграфы
        let paragraphs = text.components(separatedBy: "\n\n")
        
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
                if paragraph.hasPrefix("##") {
                    // Заголовок
                    Text(paragraph.replacingOccurrences(of: "## ", with: ""))
                        .font(AppFont.headline(18))
                        .foregroundStyle(Color.theme.goldAccent)
                } else if paragraph.hasPrefix("**") && paragraph.hasSuffix("**") {
                    // Жирный текст
                    Text(paragraph.replacingOccurrences(of: "**", with: ""))
                        .font(AppFont.body())
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                } else {
                    // Обычный параграф
                    Text(paragraph)
                        .font(AppFont.body())
                        .foregroundStyle(Color.theme.textSecondary)
                        .lineSpacing(4)
                }
            }
        }
        .textSelection(.enabled)
    }
}

// MARK: - Action Button
private struct ActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                
                Text(label)
                    .font(AppFont.caption(10))
            }
            .foregroundStyle(Color.theme.textSecondary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.theme.backgroundMiddle.ignoresSafeArea()
        
        ScrollView {
            InterpretationView(
                interpretation: """
                ## Droga Duszo...
                
                Karty szepczą mi twoją historię, a ja widzę w nich głębokie przesłanie...
                
                **Głupiec** w pozycji przeszłości mówi o czasie, gdy byłaś wolna od trosk, gdy świat był pełen możliwości. To energia niewinności i spontaniczności.
                
                Teraz, gdy **Wieża** stoi przed tobą, rozumiem, że przechodzisz przez transformację. To nie jest zniszczenie - to oczyszczenie.
                
                A **Gwiazda** w przyszłości... Ach, to najpiękniejsze przesłanie! Po każdej burzy przychodzi spokój, po każdym upadku - nadzieja.
                
                Pamiętaj: jesteś silniejsza, niż myślisz. ✨
                """,
                isStreaming: false
            ) {
                print("Save")
            } onShare: {
                print("Share")
            }
            .padding()
        }
    }
}
