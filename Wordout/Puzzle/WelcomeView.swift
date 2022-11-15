//
//  WelcomeView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct WelcomeView: View {
    
    var playMode: PlayMode
    
    var primaryAction: (Date) -> ()
    var secondaryAction: () -> ()
    
    @State var date: Date = Date().addingTimeInterval(-1 * 24 * 60 * 60)
    
    var namespace: Namespace.ID
    
    var caption: String {
        
        if playMode == .dailyPuzzle {
            let p = Puzzle.dailyPuzzle.loadingFromProgress()
            
            if p.completed {
                return playMode.welcomeViewCaption![2]
            }
            else if p.totalGuessed > 0 {
                return playMode.welcomeViewCaption![1]
            }
            else {
                return playMode.welcomeViewCaption![0]
            }
        }
        else {
            return (playMode.welcomeViewCaption ?? ["Missing Caption"])[0]
        }
    }
    
    var primaryButtonText: String {
        
        if playMode == .dailyPuzzle {
            let p = Puzzle.dailyPuzzle.loadingFromProgress()
            
            if p.completed {
                return playMode.welcomeViewPrimaryButtonText![2]
            }
            else if p.totalGuessed > 0 {
                return playMode.welcomeViewPrimaryButtonText![1]
            }
            else {
                return playMode.welcomeViewPrimaryButtonText![0]
            }
        }
        else {
            return (playMode.welcomeViewPrimaryButtonText ?? ["Button"])[0]
        }
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            // Icon
            
            HStack {
                Spacer()
                Image(systemName: playMode.symbolName)
                    .foregroundColor(.white)
                .font(.system(size: 60))
                Spacer()
            }
            
            // Title
            
            Text(playMode.name)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
                .matchedGeometryEffect(id: "title", in: namespace)
            
            // Caption
            
            Text(caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            // Date Picker
            
            if playMode == .archive {
                DatePicker("Puzzle date", selection: $date, in: (Date.referenceDate...Date()), displayedComponents: [.date])
                    .padding()
                    .datePickerStyle(.compact)
                    .colorScheme(.dark)
                    .background(RoundedRectangle(cornerRadius: 14).foregroundColor(.black).opacity(0.1))
                    .padding()
            }
            
            // Primary button
            
            WelcomeViewButton(text: primaryButtonText, action: {primaryAction(date)}, primary: true)
                .transition(.asymmetric(insertion: .opacity, removal: .scale))
                .padding(.top, 40)
            
            // Secondary button
            
            WelcomeViewButton(text: playMode.welcomeViewSecondaryButtonText ?? "Button 2", action: secondaryAction, primary: false)
                .transition(.asymmetric(insertion: .opacity, removal: .scale))
                .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .background(playMode.color)
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        WelcomeView(playMode: .dailyPuzzle, primaryAction: {date in}, secondaryAction: {}, namespace: namespace)
    }
}

struct WelcomeViewButton: View {
    
    var text: String
    var action: () -> ()
    var primary: Bool
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(primary ? Color.accentColor : Color.white)
                .padding(.vertical)
                .frame(width: 150)
                .background(
                    Capsule()
                        .foregroundColor(primary ? Color.white : Color.black)
                        .opacity(primary ? 1 : 0.1)
                )
        }
    }
}
