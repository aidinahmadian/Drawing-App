//
//  Haptics.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/21/24.
//

import UIKit

enum HapticFeedbackType {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case soft
    case rigid
    case selection
}

func generateHapticFeedback(_ type: HapticFeedbackType) {
    switch type {
    case .light:
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    case .medium:
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    case .heavy:
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    case .success:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    case .warning:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    case .error:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    case .soft:
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    case .rigid:
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    case .selection:
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
