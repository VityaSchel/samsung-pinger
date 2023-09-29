//
//  ContentView.swift
//  samsung-pinger
//
//  Created by Виктор Щелочков on 28.09.2023.
//

import SwiftUI

struct ContentView: View {
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
                Text("settings_label")
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
                Text("instructions_label")
                    .fontWeight(.bold)
                Button(action: {
                    if let url = URL(string: "https://github.com/vityaschel/samsung-pinger#setup") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("instructions_link").underline()
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
            field(title: NSLocalizedString("settings_field_ping_text", comment: "Ping text (optional)"), placeholder: "settings_field_ping_placeholder", text: $pingText)
            field(title: "JSESSIONID:", text: $jsessionID)
            field(title: "WMONID:", text: $wmonID)
            field(title: "Device ID:", text: $deviceID)
            HStack {
                Button(action: saveFields) {
                    Text("save_button")
                }
                if showMessage {
                    Text("saved_successfully_message")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .frame(width: 400, alignment: .leading)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("validation_error_message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func saveFields() {
        if jsessionID.count == 0 {
            alertMessage = "JSESSIONID" + NSLocalizedString("required_field_error", comment: "Required field")
            showAlert = true
            return
        }
        if wmonID.count == 0 {
            alertMessage = "WMONID" + NSLocalizedString("required_field_error", comment: "Required field")
            showAlert = true
            return
        }
        if deviceID.count == 0 {
            alertMessage = "Device ID" + NSLocalizedString("required_field_error", comment: "Required field")
            showAlert = true
            return
        }
        if !NSPredicate(format: "SELF MATCHES %@", "^[0-9]+$").evaluate(with: deviceID) {
            alertMessage = NSLocalizedString("device_id_validation_error", comment: "Device ID must only consist of numbers")
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
        ContentView()
    }
}

func field(title: String, placeholder: String = "", text: Binding<String>) -> some View {
    VStack(alignment: .leading, spacing: 5) {
        Text(title).fontWeight(.semibold)
        TextField(placeholder, text: text)
    }
    .padding(.bottom, 5)
}
