//
//  WidgetInstructionsView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 26/12/2022.
//

import SwiftUI

struct WidgetInstructionsView: View {
    
    @Environment(\.presentationMode)  var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    
                    Text("Fancy getting a preview of the daily puzzle from the comfort of your home screen? This is now possible with the all-new \(Domingo.appName.capitalized) widget!")
                    
                    Text("To add the widget, hold down your finger on your home screen then press the '+' in the top left corner.")
//
                    Spacer()
                    
                    HStack{
                        
                        GeometryReader { reader in
                            Spacer()
                            Image("DomingoWidget")
                                .resizable()
                                .scaledToFill()
                                .frame(width: reader.size.width * 0.7, height: reader.size.width * 0.7)
                                .clipped()
                                .clipShape(Circle())
                                .shadow(radius: 20)
                                .background {
                                    Rectangle()
                                        .frame(width: reader.size.width * 0.6, height: reader.size.width * 0.6)
                                        .rotationEffect(.degrees(45))
                                        .foregroundColor(Domingo.themeColor)
                                }
                            Spacer()
                        }
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Meet the Widget")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {presentationMode.wrappedValue.dismiss()}
                }
            }
        }
    }
}

struct WidgetInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetInstructionsView()
    }
}
