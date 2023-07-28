//
//  ML_iOSApp.swift
//  ML_iOS
//
//  Created by Daniil Ignatev on 19.07.23.
//

import SwiftUI

@main
struct ML_iOSApp: App {
    @State private var selectedTab = 1
    
    var body: some Scene {
        let firstTab_UI = Regression1_UI()
        let secondTab_UI = Figures_Recogniser_UI()
        
        WindowGroup {
            TabView{
                firstTab_UI
                    .tabItem {
                        Text("Linear regression")
                    }
                
                secondTab_UI
                    .tabItem {
                        Text("Neural network")
                    }
            }
            .frame(idealWidth: 600, idealHeight: 600)
        }
    }
}
