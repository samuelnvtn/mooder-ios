//
//  WrapTagsView.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//
import SwiftUI

struct WrapTagsView: View {
    let tags: [MoodTagModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(tags) { tag in
                Label {
                    Text(tag.name)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                } icon: {
                    Image(systemName: tag.iconName)
                        .foregroundColor(.accentColor)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Capsule())
            }
        }
    }
}
