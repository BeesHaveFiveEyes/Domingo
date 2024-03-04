
import SwiftUI

// Play a 'positive' haptic
func playSuccessHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

// Play a 'negative' warning haptic
func playErrorHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.error)
}
