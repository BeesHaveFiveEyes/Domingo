//
//  SharePuzzleViewPreview.swift
//  Wordout
//
//  Created by Alasdair Casperd on 30/11/2022.
//

import SwiftUI

struct SharePuzzleViewPreview: View {
    
    var puzzle: Puzzle
        
    @State private var hideProgress = true
    @State private var accentBackground = false
    
    @State var image = Image("")
    
    var shareView: some View {
        SharePuzzleView(puzzle: puzzle)
            .accentColor(Domingo.themeColor)
            .frame(width: 430.0*CGFloat(SharePuzzleView.scale), height: 430.0*CGFloat(SharePuzzleView.scale))
    }
    
    @MainActor @available(iOS 16.1, *)
    private func generateSnapshot() -> UIImage {
        let renderer = ImageRenderer(content: shareView)
        renderer.scale = UIScreen.main.scale
        
        // Work around for bug in iOS 16 where .scale is ineffective
        
        let image = renderer.uiImage ?? UIImage()
        let data = image.pngData() ?? Data()
        return UIImage(data: data) ?? UIImage()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Hide Current Progress", isOn: $hideProgress)
                        .icon("eraser.line.dashed")
                    Toggle("Accent Background", isOn: $accentBackground)
                        .icon("paintbrush")
                }
                
                Section {
                    if #available(iOS 16.1, *) {
                        ShareLink(item: Image(uiImage: generateSnapshot()), preview:
                                    SharePreview("Share Daily Puzzle", image: Image(uiImage: generateSnapshot()))) {
                            HStack{
                                Spacer()
                                Text("Share Image")
                                Spacer()
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .navigationTitle("Share Puzzle")
        }
    }
}

struct SharePuzzleViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        SharePuzzleViewPreview(puzzle: .dailyPuzzle)
    }
}
