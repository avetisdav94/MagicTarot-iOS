//
//  TarotCard.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import Foundation


struct TarotCard: Identifiable, Codable {
    var id = UUID()
    let name: String
    let imageName: String
    let description: String
    let uprightMeaning: String
    let reversedMeaning: String
    let keyWords: [String]
}

 let mockCards = [
    TarotCard(
        name: "The Fool",
        imageName: "00-fool",
        description: "A young man stands on the edge of a cliff, looking up at the sky with a small dog at his heels. He carries a white rose and a small bundle, representing innocence and the experiences yet to come.",
        uprightMeaning: "Represents new beginnings, having faith in the future, being inexperienced, and embracing enthusiasm. It is a call to take a leap of faith.",
        reversedMeaning: "Indicates recklessness, being naive, taking unnecessary risks, or holding back from a new adventure due to fear.",
        keyWords: ["Beginnings", "Innocence", "Spontaneity", "Faith"]
    ),
    TarotCard(
        name: "The Magician",
        imageName: "magician",
        description: "A figure stands with one arm pointing to the sky and the other to the earth. On a table before him lie a cup, a pentacle, a sword, and a wand—the four elements of the tarot.",
        uprightMeaning: "Signifies manifestation, resourcefulness, and the power to turn dreams into reality. You have all the tools you need to succeed.",
        reversedMeaning: "Suggests manipulation, untapped potential, poor planning, or using one's skills for the wrong reasons.",
        keyWords: ["Manifestation", "Power", "Resourcefulness", "Action"]
    ),
    TarotCard(
        name: "The High Priestess",
        imageName: "high_priestess",
        description: "A serene woman sits between two pillars, one black and one white, representing duality. She holds a scroll and wears a crown showing the phases of the moon.",
        uprightMeaning: "A call to trust your intuition and look for answers within. It represents mystery, subconscious knowledge, and spiritual insight.",
        reversedMeaning: "Indicates a disconnect from intuition, hidden motives, superficiality, or secrets that are causing confusion.",
        keyWords: ["Intuition", "Mystery", "Subconscious", "Wisdom"]
    )
 ]
