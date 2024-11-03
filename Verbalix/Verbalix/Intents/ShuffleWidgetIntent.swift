//
//  ShuffleWidgetIntent.swift
//  Verbalix
//
//  Created by Alex Beals on 11/3/24.
//

import AppIntents

struct ShuffleWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Shuffle Widget"

    func perform() async throws -> some IntentResult {
        return .result()
    }
}
