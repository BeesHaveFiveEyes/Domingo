//
//  PlayModes.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct PlayMode: Equatable {
    
    var name: String
    var menuTitle: String
    var symbolName: String
    var menuAccent: Bool
    var welcomeViewCaption: [String]?
    var welcomeViewPrimaryButtonText: [String]?
    var welcomeViewSecondaryButtonText: String?
    var completeViewTitleExtension: String?
    var completeViewCaption: String?
    var completeViewPrimaryButtonText: String?
    var completeViewSecondaryButtonText: String?
    var color: Color
    var showTopBar: Bool
            
    static let dailyPuzzle = PlayMode(
        name: "Daily Puzzle",
        menuTitle: "Daily Puzzle",
        symbolName: "calendar",
        menuAccent: true,
        welcomeViewCaption: ["Ready for your daily puzzle?", "Will you solve today's puzzle?", "You've already completed today's puzzle."],
        welcomeViewPrimaryButtonText: ["Play", "Resume", "Review"],
        welcomeViewSecondaryButtonText: "Quit",
        completeViewTitleExtension: "Complete!",
        completeViewCaption: "Congratulations! You've completed today's daily puzzle. Check back tomorrow for a new one!",
        completeViewPrimaryButtonText: "Done",
        color: WordoutApp.themeColor,
        showTopBar: true)
    
    static let categories = PlayMode(
        name: "Categories",
        menuTitle: "Categories",
        symbolName: "books.vertical.fill",
        menuAccent: false,
        color: WordoutApp.themeColor,
        showTopBar: false)
    
    static let archive = PlayMode(
        name: "Archived Puzzle",
        menuTitle: "Archived Puzzles",
        symbolName: "archivebox.fill",
        menuAccent: false,
        welcomeViewCaption: ["Choose a date below to replay the daily puzzle from any day of your choice."],
        welcomeViewPrimaryButtonText: ["Select"],
        welcomeViewSecondaryButtonText: "Quit",
        completeViewTitleExtension: "Complete!",
        completeViewCaption: "Congratulations! You've finished this puzzle.",
        completeViewPrimaryButtonText: "Done",
        color: WordoutApp.themeColor,
        showTopBar: true)
    
    static let createPuzzle = PlayMode(
        name: "Create Puzzle",
        menuTitle: "Create Puzzle",
        symbolName: "paintbrush.fill",
        menuAccent: false,
        welcomeViewCaption: ["Want to create your own puzzle?"],
        welcomeViewPrimaryButtonText: ["Begin"],
        welcomeViewSecondaryButtonText: "Quit",
        color: WordoutApp.themeColor,
        showTopBar: false)
    
    static let importPuzzle = PlayMode(
        name: "Import Puzzle",
        menuTitle: "Import Puzzle",
        symbolName: "square.and.arrow.down.fill",
        menuAccent: false,
        color: WordoutApp.themeColor,
        showTopBar: false)
    
    static let statistics = PlayMode(
        name: "Statistics",
        menuTitle: "Statistics",
        symbolName: "trophy.fill",
        menuAccent: false,
        color: WordoutApp.themeColor,
        showTopBar: false)
    
    static let settings = PlayMode(
        name: "Settings",
        menuTitle: "Settings",
        symbolName: "gearshape.fill",
        menuAccent: false,
        color: WordoutApp.themeColor,
        showTopBar: false)
}
