//
//  samsung_pingerApp.swift
//  samsung-pinger
//
//  Created by Виктор Щелочков on 28.09.2023.
//

import SwiftUI
import Foundation
import AppKit

class WindowState: ObservableObject {
  @Published var ringAction: Bool = false
}

@main
struct samsung_pingerApp: App {
    @State private var windowStateMap: [UUID: WindowState] = [:]
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
          MainView(windowStateMap: $windowStateMap)
        }
        .windowResizability(.contentSize)
      }
}

struct MainView: View {
    @State private var ringAction: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var ringState: String = ""
    let windowId: UUID
    @StateObject private var s = WindowState()
    @Binding private var windowStateMap: [UUID: WindowState]
    
    init(windowStateMap: Binding<[UUID: WindowState]>) {
        self.windowId = UUID()
        self._windowStateMap = windowStateMap
      }
    
    var body: some View {
        let windowState = WindowState()
        
      Group {
          if !(s.ringAction) {
            ContentView(windowState: windowState)
                .frame(width: 400)
                .fixedSize()
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    for window in NSApplication.shared.windows {
                        window.standardWindowButton(.zoomButton)?.isEnabled = false
                    }
                })
        } else {
            RingingView(windowState: windowState, showAlert: $showAlert, alertMessage: $alertMessage, ringState: $ringState)
                .frame(width: 400, height: 300)
                .fixedSize()
//                        .onAppear {
//                          setTitleBarVisible(false)
//                        }
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    for window in NSApplication.shared.windows {
                        window.standardWindowButton(.zoomButton)?.isEnabled = false
                    }
                })
                .onDisappear {
                    NSApplication.shared.terminate(self)
                  }
                .onAppear {
                    ring()
                }
        }
      }
      .onAppear {
        windowStateMap[windowId] = windowState
      }
      .onOpenURL { url in
          handle(url: url, windowId: windowId)
          print(windowStateMap, url, windowId, self._windowStateMap)
      }
    }

    
    private func handleNewWindow(id: UUID) {
       // Logic to decide what to do with a new window
     }
    
    private func handle(url: URL, windowId: UUID) {
        if url.absoluteString == "samsung-pinger-widget://ring" {
            
            s.ringAction = true
        }
    }
    
    func showAlert(message: String) {
        self.showAlert = true
        self.alertMessage = message
    }
    
    private func ring() {
        ringState = "connecting"
        
        let loginURL = URL(string: "https://smartthingsfind.samsung.com/chkLogin.do")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the cookies, you may need to replace these with actual values
        let cookies = "WMONID=\(UserDefaults.standard.string(forKey: "wmonID") ?? ""); JSESSIONID=\(UserDefaults.standard.string(forKey: "jsessionID") ?? "")"
        request.setValue(cookies, forHTTPHeaderField: "Cookie")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                showAlert(message: "Couldn't make a request to get _csrf: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let _ = data
            
            if let httpResponse = response as? HTTPURLResponse, let csrf = httpResponse.allHeaderFields["_csrf"] as? String {
                
                print("Got _csrf value: ", csrf)
                
                let addOperationURL = URL(string: "https://smartthingsfind.samsung.com/dm/addOperation.do?_csrf=\(csrf)")!
                var request = URLRequest(url: addOperationURL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let cookies = "WMONID=\(UserDefaults.standard.string(forKey: "wmonID") ?? ""); JSESSIONID=\(UserDefaults.standard.string(forKey: "jsessionID") ?? "")"
                request.setValue(cookies, forHTTPHeaderField: "Cookie")
                
                let operationData = [
                    "dvceId": UserDefaults.standard.string(forKey: "deviceID") ?? "",
                    "operation": "RING",
                    "lockMessage": UserDefaults.standard.string(forKey: "pingText") ?? "",
                    "status": "start"
                ]
                
                print("Ready to make ring operation request...")
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: operationData) {
                    request.httpBody = jsonData
                    
                    ringState = "ringing"
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if (error != nil) {
                            showAlert(message: "Couldn't make a request to ring endpoint")
                        }
                    }
                    
                    task.resume()
                }
            }
        }

        task.resume()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
