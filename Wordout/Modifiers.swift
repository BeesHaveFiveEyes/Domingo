//
//  Modifiers.swift
//  Wordout
//
//  Created by Alasdair Casperd on 07/11/2022.
//

import SwiftUI

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
        
        VStack {
            EmptyView()
            if showingContent {
                content
                    .transition(.opacity)
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

struct Icon: ViewModifier {
    
    var systemName: String
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: systemName)
                .frame(width: 20)
                .padding(.trailing, 5)
                .foregroundColor(.accentColor)
            content
        }
    }
}


extension View {
        
    func scaleInAfter(_ delay: Double) -> some View {
        modifier(ScaleIn(delay: delay))
    }
    
    func scaleInAfter(offset: Int, withDelay delay: Double = WordoutApp.animationDelay) -> some View {
        modifier(ScaleIn(delay: WordoutApp.animationIncrement * Double(offset) + delay))
    }
    
    func fadeInAfter(_ delay: Double) -> some View {
        modifier(FadeIn(delay: delay))
    }
    
    func fadeInAfter(offset: Int, withDelay delay: Double = WordoutApp.animationDelay) -> some View {
        modifier(FadeIn(delay: WordoutApp.animationIncrement * Double(offset) + delay))
    }
    
    func slideInAfter(_ delay: Double) -> some View {
        modifier(SlideIn(delay: delay))
    }
    
    func slideInAfter(offset: Int, withDelay delay: Double = WordoutApp.animationDelay) -> some View {
        modifier(SlideIn(delay: WordoutApp.animationIncrement * Double(offset) + delay))
    }
    
    func icon(_ systemName: String) -> some View {
        modifier(Icon(systemName: systemName))
    }
}
