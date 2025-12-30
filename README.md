# 🔮 Magic Tarot - AI Powered Spiritual Guide

**Magic Tarot** is a premium iOS application that combines the ancient art of Tarot with modern Artificial Intelligence.
Unlike standard apps with static text, Magic Tarot uses **Google Gemini 1.5 Flash** to generate unique, context-aware readings based on the specific card and its orientation (Upright/Reversed).

Acting as a mystical guide ("Witch Veronica"), the app provides personalized advice, supporting **English**, **Polish**, and **Russian** languages.

---

## ✨ Key Features

### 🌟 Core Experience
- **Daily Card Ritual:** A beautiful "Card of the Day" experience with haptic feedback and animations.
- **AI Oracle:** Real-time streaming interpretation of cards using **Generative AI** (Gemini).
- **Magical Atmosphere:** Custom "Glassmorphism" design system, animated star backgrounds, and golden glowing effects.

### 🃏 Interactive Deck
- **Smart Card Picker:** Filter by Arcana (Major/Minor) or Suit (Wands, Cups, Swords, Pentacles).
- **Search:** Instant search by card name in multiple languages.
- **Visuals:** High-quality card assets with 3D flip animations and dynamic borders.

### 🌍 Localization
Fully localized interface and AI responses:
- 🇺🇸 English
- 🇵🇱 Polish
- 🇷🇺 Russian

---

## 🛠 Technical Stack

The project is built with **Clean Architecture** principles and modern Swift features.

- **Language:** Swift 5.10
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel) + Input/Output Pattern
- **Concurrency:** Swift Concurrency (async/await, Task, MainActor)
- **AI Integration:** Google Generative AI SDK (Gemini API)
- **Design System:** Custom ViewModifiers, Extensions, and Theme Manager.
- **Localization:** String Catalogs (.xcstrings) with `String(localized:)`.

---

## 🏗 Architecture Overview

The app follows a strict separation of concerns:

```text
MagicTarot/
├── App/                # App Entry Point & Configuration
├── Models/             # Data Structures (TarotCard, GeminiModels)
├── ViewModels/         # Business Logic (HomeViewModel)
├── Views/
│   ├── Screens/        # Full Screen Views (Home, CardPicker, Intro)
│   └── Components/     # Reusable UI (GlassCard, MagicButton, TypingText)
├── Services/           # Networking & AI Service
└── Core/               # Design System, Extensions, Constants
