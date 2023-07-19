//
//  ML_iOSApp.swift
//  ML_iOS
//
//  Created by Daniil Ignatev on 19.07.23.
//

import SwiftUI

@main
struct ML_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            Regression1_UI()
                .frame(idealWidth: 600, idealHeight: 600)
        }
    }
}
