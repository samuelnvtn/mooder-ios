//
//  GPTservice.swift
//  Mooder
//
//  Created by Fietstopa on 21.06.2025.
//


import Foundation

struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }

    let choices: [Choice]
}
