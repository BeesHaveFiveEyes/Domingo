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

struct Icon: ViewModifier {
    
    var systemName: String
    var color: Color
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: systemName)
                .frame(width: 20)
                .padding(.trailing, 5)
                .foregroundColor(color)
            content
        }
    }
}

struct GlobalPosition: ViewModifier {

    var point: CGPoint
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .position(x: proxy.size.width / 2 + (point.x - proxy.frame(in: CoordinateSpace.global).midX),
                          y: proxy.size.height / 2 + (point.y - proxy.frame(in: CoordinateSpace.global).midY))
        }
    }
}

extension View {
        
    func scaleInAfter(_ delay: Double) -> some View {
        modifier(ScaleIn(delay: delay))
    }
    
    func scaleInAfter(offset: Int, withDelay delay: Double = Domingo.animationDelay) -> some View {
        modifier(ScaleIn(delay: Domingo.animationIncrement * Double(offset) + delay))
    }
    
    func fadeInAfter(_ delay: Double) -> some View {
        modifier(FadeIn(delay: delay))
    }
    
    func fadeInAfter(offset: Int, withDelay delay: Double = Domingo.animationDelay) -> some View {
        modifier(FadeIn(delay: Domingo.animationIncrement * Double(offset) + delay))
    }
    
    func slideInAfter(_ delay: Double) -> some View {
        modifier(SlideIn(delay: delay))
    }
    
    func slideInAfter(offset: Int, withDelay delay: Double = Domingo.animationDelay) -> some View {
        modifier(SlideIn(delay: Domingo.animationIncrement * Double(offset) + delay))
    }
    
    func icon(_ systemName: String, color: Color = .accentColor) -> some View {
        modifier(Icon(systemName: systemName, color: color))
    }
    
    func globalPosition (_ point: CGPoint) -> some View {
        self.modifier(GlobalPosition(point: point))
    }
}

struct InfiniteScroller<Content: View>: View {
    
    var contentWidth: CGFloat
    var content: (() -> Content)
    
    var animationLength = 5.0
    
    @State
    var xOffset: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    content()
                    content()
                }
                .offset(x: xOffset, y: 0)
        }
        .disabled(true)
        .onAppear {
            withAnimation(.linear(duration: animationLength).repeatForever(autoreverses: false)) {
                xOffset = -contentWidth
            }
        }
    }
}
