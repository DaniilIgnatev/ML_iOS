//
//  ML_iOSApp.swift
//  ML_iOS
//
//  Created by Daniil Ignatev on 19.07.23.
//

import SwiftUI
import ML

@main
struct ML_iOSApp: App {
    @State private var selectedTab = 0
    
    var body: some Scene {
        let firstTab_UI = Figures_Recogniser_UI()
        let secondTab_UI = Regression1_UI()
        
        WindowGroup {
            TabView(selection: $selectedTab){
                firstTab_UI
                    .tabItem {
                        Text("NEURAL NETWORK")
                    }
                
                secondTab_UI
                    .tabItem {
                        Text("LINEAR REGRESSION")
                    }
            }
            .frame(idealWidth: 600, idealHeight: 600)
        }
    }
}
