
import SwiftUI

// View modifiers to automatically animate-in views as they appear

extension View {
        
    func scaleInAfter(_ delay: Double) -> some View {
        modifier(ScaleIn(delay: delay))
    }
    
    func scaleInAfter(offset: Int, withDelay delay: Double = Animation.animationDelay) -> some View {
        modifier(ScaleIn(delay: Animation.animationIncrement * Double(offset) + delay))
    }
    
    func fadeInAfter(_ delay: Double) -> some View {
        modifier(FadeIn(delay: delay))
    }
    
    func fadeInAfter(offset: Int, withDelay delay: Double = Animation.animationDelay) -> some View {
        modifier(FadeIn(delay: Animation.animationIncrement * Double(offset) + delay))
    }
    
    func slideInAfter(_ delay: Double) -> some View {
        modifier(SlideIn(delay: delay))
    }
    
    func slideInAfter(offset: Int, withDelay delay: Double = Animation.animationDelay) -> some View {
        modifier(SlideIn(delay: Animation.animationIncrement * Double(offset) + delay))
    }
}


struct ScaleIn: ViewModifier {
    
    var delay: Double
    @State private var showingContent = false
    
    func body(content: Content) -> some View {
        
        VStack {
            EmptyView()
            if showingContent {
                content
                    .transition(.scale)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    showingContent = true
                }
            }
        }
    }
}

struct FadeIn: ViewModifier {
    
    var delay: Double
    @State private var showingContent = false
    
    func body(content: Content) -> some View {
        
        content.opacity(showingContent ? 1 : 0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    showingContent = true
                }
            }
        }
    }
}

struct SlideIn: ViewModifier {
    
    var delay: Double
    @State private var showingContent = false
    
    func body(content: Content) -> some View {
        
        VStack {
            EmptyView()
            if showingContent {
                content
                    .transition(.slide.combined(with: .opacity))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    showingContent = true
                }
            }
        }
    }
}

extension Animation {
    
    // The per-item offset used in the app's transition animations
    static public let animationIncrement = 0.06
    
    // The default delay before the app's transition animations begin
    static public let animationDelay = 0.3
}
