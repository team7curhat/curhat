//
//  NavigationManager.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 14/08/25.
//

import SwiftUI
import Combine

class NavigationManager: ObservableObject{
    static let shared = NavigationManager()
    private init(){}
    
    @Published var hasHomeActive: Bool = false
    @Published var hasStoryActive: Bool = false
    
    func setHomeActive(setHomeActive: Bool){
        hasHomeActive = setHomeActive
    }
    
    func setStoryActive(setStoryActive: Bool){
        hasStoryActive = setStoryActive
    }
    
}
