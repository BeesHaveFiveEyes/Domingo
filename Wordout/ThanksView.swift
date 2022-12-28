//
//  ThanksView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 25/11/2022.
//

import SwiftUI

struct ThanksView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    
    let columns = [GridItem(.adaptive(minimum: 90), spacing: 14)]
    let people = ["Rachel", "Martin", "Catherine", "Ru", "Hannah", "Sophie", "Matt", "Nina", "Danielle", "Harmann", "Sam", "Paul", "Ursula", "Ben", "Meg", "Henry", "Scott", "David", "Patty", "Marion", "Euan"]
    
    var grid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
            ForEach(people, id: \.self) { person in
                Text(person)
                    .foregroundColor(.secondary)
                    .fadeInAfter(offset: people.firstIndex(of: person)!)
                    .padding(4)
            }
        }
        .padding()
    }
    
    var body: some View {
        
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Thanks to all the amazing people who help test, improve and inspire \(Domingo.appName)! Your feedback is beyond helpful and I'm so grateful to each of you.")
                        .padding(.top)
                    Divider()
                    
                    grid
                    
                    Divider()
                    
                    (Text("And thank ") + Text("you").italic() + Text(" for downloading!"))
                            .multilineTextAlignment(.leading)
                            .padding(.vertical)
                    Text("~ Alasdair")
                }
                .padding(.horizontal)
                                
            }
            .padding(.top)
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Thank You ♡")
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct ThanksView_Previews: PreviewProvider {
    static var previews: some View {
        ThanksView()
    }
}
