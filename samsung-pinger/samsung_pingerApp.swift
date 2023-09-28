//
//  samsung_pingerApp.swift
//  samsung-pinger
//
//  Created by Виктор Щелочков on 28.09.2023.
//

import SwiftUI

@main
struct samsung_pingerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 400 )
                .fixedSize()
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    for window in NSApplication.shared.windows {
                        window.standardWindowButton(.zoomButton)?.isEnabled = false
                    }
                })
        }.windowResizability(.contentSize)
    }
}
