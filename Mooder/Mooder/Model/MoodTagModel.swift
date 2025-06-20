//
//  MoodTagModel.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//
import Foundation

struct MoodTagModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    let iconName: String

    init(from tag: MoodTag) {
        self.id = tag.id ?? UUID()
        self.name = tag.name ?? "Unnamed"
        self.iconName = tag.icon ?? "questionmark"
    }
}
