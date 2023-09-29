//
//  ContentView.swift
//  samsung-pinger
//
//  Created by Виктор Щелочков on 28.09.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var windowState: WindowState
    
    @State private var jsessionID: String = UserDefaults.standard.string(forKey: "jsessionID") ?? ""
    @State private var wmonID: String = UserDefaults.standard.string(forKey: "wmonID") ?? ""
    @State private var deviceID: String = UserDefaults.standard.string(forKey: "deviceID") ?? ""
    @State private var pingText: String = UserDefaults.standard.string(forKey: "pingText") ?? ""
    
    @State private var showMessage: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("To be able to ping your device, this widget needs your Samsung's SmartThingsFind tokens and Device ID. This information never leaves your computer and won't be shared with anyone. You can review source code at ")
                Button(action: {}) {
                    Text("https://github.com/vityaschel/samsung-pinger").underline()
                        .foregroundColor(Color.blue)
                }.buttonStyle(PlainButtonStyle())
                .onHover { inside in
                    if inside {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 370, alignment: .leading)
            .padding(.bottom, 20)
            HStack {
                Text("Don't know how to find these values?")
                    .fontWeight(.bold)
                Button(action: {
                    if let url = URL(string: "https://github.com/vityaschel/samsung-pinger#setup") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("View instructions").underline()
                        .foregroundColor(Color.blue)
                }.buttonStyle(PlainButtonStyle())
                .onHover { inside in
                    if inside {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
            .padding(.bottom, 10)
            field(title: "Ping text (optional):", placeholder: "Samsung Pinger is ringing this phone!", text: $pingText)
            field(title: "JSESSIONID:", text: $jsessionID)
            field(title: "WMONID:", text: $wmonID)
            field(title: "Device ID:", text: $deviceID)
            HStack {
                Button(action: saveFields) {
                    Text("Save")
                }
                if showMessage {
                    Text("Saved successfully!")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .frame(width: 400, alignment: .leading)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func saveFields() {
        if jsessionID.count == 0 {
            alertMessage = "JSESSIONID is a required field. If you don't know where to find this token, please refer to instructions in README.md file on GitHub"
            showAlert = true
            return
        }
        if wmonID.count == 0 {
            alertMessage = "WMONID is a required field. If you don't know where to find this token, please refer to instructions in README.md file on GitHub"
            showAlert = true
            return
        }
        if deviceID.count == 0 {
            alertMessage = "Device ID is a required field. If you don't know where to find this token, please refer to instructions in README.md file on GitHub"
            showAlert = true
            return
        }
        if !NSPredicate(format: "SELF MATCHES %@", "^[0-9]+$").evaluate(with: deviceID) {
            alertMessage = "Device ID must only consist of numbers"
            showAlert = true
            return
        }
        
        persistFields()
    }
        
    func persistFields() {
        showMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            showMessage = false
        }
        
        UserDefaults.standard.set(jsessionID, forKey: "jsessionID")
        UserDefaults.standard.set(wmonID, forKey: "wmonID")
        UserDefaults.standard.set(deviceID, forKey: "deviceID")
        UserDefaults.standard.set(pingText, forKey: "pingText")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(windowState: WindowState())
    }
}

func field(title: String, placeholder: String = "", text: Binding<String>) -> some View {
    VStack(alignment: .leading, spacing: 5) {
        Text(title).fontWeight(.semibold)
        TextField(placeholder, text: text)
    }
    .padding(.bottom, 5)
}
