//
//  samsung_pingerApp.swift
//  samsung-pinger
//
//  Created by Виктор Щелочков on 28.09.2023.
//

import SwiftUI
import Foundation

@main
struct samsung_pingerApp: App {
    @State private var ringAction: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var ringState: String = ""
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !ringAction {
                    ContentView()
                        .frame(width: 400)
                        .fixedSize()
//                        .onAppear {
//                          setTitleBarVisible(true)
//                        }
                        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                            for window in NSApplication.shared.windows {
                                window.standardWindowButton(.zoomButton)?.isEnabled = false
                            }
                        })
//                        .onDisappear {
//                            NSApplication.shared.terminate(self)
//                          }
                } else {
                    RingingView(showAlert: $showAlert, alertMessage: $alertMessage, ringState: $ringState)
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
            .onOpenURL { url in
                handle(url: url)
            }
        }
        .windowResizability(.contentSize)
    }
    
    private func handle(url: URL) {
        if url.absoluteString == "samsung-pinger-widget://ring" {
            
            ringAction = true
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
