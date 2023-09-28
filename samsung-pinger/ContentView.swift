//
//  ContentView.swift
//  samsung-pinger
//
//  Created by Виктор Щелочков on 28.09.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var jsessionID1: String = ""
    @State private var jsessionID2: String = ""
    @State private var wmonID: String = ""
    @State private var deviceID: String = ""
    @State private var pingText: String = ""
    @State private var showMessage: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("To be able to ping your device, this widget needs your Samsung's SmartThingsFind tokens and Device ID. This information never leaves your computer and won't be shared with anyone. You can review source code at ")
                Button(action: {
                   // link action here
                }) {
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
              VStack(alignment: .leading) {
                Text("Ping text (optional):").fontWeight(.semibold)
                TextField("Samsung Pinger is ringing this phone!", text: $pingText)
              }
              .padding(.bottom, 10)
              VStack(alignment: .leading) {
                Text("JSESSIONID:").fontWeight(.semibold)
                TextField("", text: $jsessionID2)
              }
              .padding(.bottom, 10)
              VStack(alignment: .leading) {
                Text("WMONID:").fontWeight(.semibold)
                TextField("", text: $wmonID)
              }
              .padding(.bottom, 10)
              VStack(alignment: .leading) {
                Text("Device ID:").fontWeight(.semibold)
                TextField("", text: $deviceID)
              }
              .padding(.bottom, 10)
            HStack {
                Button(action: {
                    self.showMessage = true
                }) {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
