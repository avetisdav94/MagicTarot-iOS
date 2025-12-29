import Foundation

// MARK: - Enums for Filtering
enum ArcanaType: String, Codable {
    case major = "major"
    case minor = "minor"
}

enum CardSuit: String, Codable {
    case wands     // Buławy (Жезлы)
    case cups      // Kielichy (Чаши)
    case swords    // Miecze (Мечи)
    case pentacles // Pentakle (Пентакли)
    case none      // Для Старших Арканов
}

// MARK: - TarotCard Structure
struct TarotCard: Identifiable, Codable {
    let id = UUID()
    let rank: Int          // Номер карты (0, 1, ... 14) для сортировки
    let name: String       // Английское название (ключ для API)
    let namePl: String     // Польское название (для UI)
    let imageName: String  // Имя картинки в Assets
    let description: String
    
    // Новые поля для фильтров
    let arcana: ArcanaType
    let suit: CardSuit
    
    let uprightMeaning: String
    let reversedMeaning: String
    let keyWords: [String]
}

// MARK: - Mock Data (Обновленная)
let mockCards: [TarotCard] = [
    // --- MAJOR ARCANA ---
    TarotCard(
        rank: 0,
        name: "The Fool",
        namePl: "Głupiec",
        imageName: "card_00_thefool", // Убедись, что картинка так называется в Assets
        description: "Początek drogi, niewinność, spontaniczność.",
        arcana: .major,
        suit: .none,
        uprightMeaning: "Nowe początki, wiara w przyszłość, entuzjazm.",
        reversedMeaning: "Lekkomyślność, ryzyko, naiwność.",
        keyWords: ["Początek", "Wolność", "Ryzyko"]
    ),
    TarotCard(
        rank: 1,
        name: "The Magician",
        namePl: "Mag",
        imageName: "card_01_magician",
        description: "Manifestacja, siła woli, mistrzostwo.",
        arcana: .major,
        suit: .none,
        uprightMeaning: "Moc twórcza, działanie, skupienie.",
        reversedMeaning: "Manipulacja, słaba wola, iluzja.",
        keyWords: ["Moc", "Działanie", "Wola"]
    ),
    TarotCard(
        rank: 2,
        name: "The High Priestess",
        namePl: "Arcykapłanka",
        imageName: "02-high_priestess",
        description: "Intuicja, tajemnica, podświadomość.",
        arcana: .major,
        suit: .none,
        uprightMeaning: "Słuchanie głosu wewnętrznego, mądrość.",
        reversedMeaning: "Sekrety, blokada intuicji.",
        keyWords: ["Intuicja", "Tajemnica", "Wiedza"]
    ),
    
    // --- MINOR ARCANA (Examples) ---
    TarotCard(
        rank: 1,
        name: "Ace of Wands",
        namePl: "As Buław",
        imageName: "wands-01",
        description: "Iskra inspiracji, nowa pasja.",
        arcana: .minor,
        suit: .wands,
        uprightMeaning: "Nowy projekt, energia, kreatywność.",
        reversedMeaning: "Brak motywacji, opóźnienia.",
        keyWords: ["Inspiracja", "Pasja", "Energia"]
    ),
    TarotCard(
        rank: 10,
        name: "Ten of Cups",
        namePl: "Dziesiątka Kielichów",
        imageName: "cups-10",
        description: "Szczęście rodzinne, spełnienie emocjonalne.",
        arcana: .minor,
        suit: .cups,
        uprightMeaning: "Harmonia, miłość, błogość.",
        reversedMeaning: "Konflikty rodzinne, rozbite marzenia.",
        keyWords: ["Rodzina", "Szczęście", "Harmonia"]
    ),
    TarotCard(
        rank: 12, // Knight (Рыцарь)
        name: "Knight of Swords",
        namePl: "Rycerz Mieczy",
        imageName: "swords-knight",
        description: "Gwałtowne działanie, ambicja.",
        arcana: .minor,
        suit: .swords,
        uprightMeaning: "Pośpiech, zdecydowanie, intelekt.",
        reversedMeaning: "Agresja, impulsywność.",
        keyWords: ["Ambicja", "Szybkość", "Intelekt"]
    ),
    TarotCard(
        rank: 14, // King (Korol)
        name: "King of Pentacles",
        namePl: "Król Pentakli",
        imageName: "pentacles-king",
        description: "Bogactwo, stabilizacja, sukces materialny.",
        arcana: .minor,
        suit: .pentacles,
        uprightMeaning: "Bezpieczeństwo finansowe, obfitość.",
        reversedMeaning: "Chciwość, materializm.",
        keyWords: ["Bogactwo", "Stabilność", "Biznes"]
    )
]
