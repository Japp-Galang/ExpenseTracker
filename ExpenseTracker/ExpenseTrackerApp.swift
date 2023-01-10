//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Japp Galang on 12/31/22.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .preferredColorScheme(.dark)
        }
    }
}
