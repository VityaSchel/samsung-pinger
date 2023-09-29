//
//  RingingView.swift
//  samsung-pinger
//
//  Created by Виктор Щелочков on 29.09.2023.
//

import SwiftUI

struct RingingView: View {
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var ringState: String
    
    var setupCompleted: Bool {
        return ringState != "incomplete-setup"
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .edgesIgnoringSafeArea(.all)
            Image("background")
                .resizable()
                .scaledToFill()
                .scaleEffect(1.25)
//                .offset(y: 20)
                .edgesIgnoringSafeArea(.all)
            
            if setupCompleted {
                VStack {
                    Text(ringState == "connecting" ? "ringing_view_connecting" : "ringing_view_ringing")
                        .foregroundColor(Color.white)
                        .font(.custom("Samsung Sharp Sans", size: 20).weight(Locale.current.languageCode == "ru" ? .bold : .medium))
                }
            } else {
                VStack {
                    Text("Samsung Pinger is not configured")
                        .foregroundColor(Color.white)
                        .font(.custom("Samsung Sharp Sans", size: 20).weight(.medium))
                    Text("To be able to ring your device, Samsung Pinger must be configured from within app's settings, that can be found when launching the app manually.")
                        .foregroundColor(Color.white)
                        .font(.custom("Samsung Sharp Sans", size: 20).weight(.medium))
                }
            }
        }
        .frame(width: 400, height: 300)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct RingingView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var isShowingAlert = false
        @State private var alertMessage = ""
        @State private var ringState = "ringing"

        var body: some View {
            RingingView(showAlert: $isShowingAlert, alertMessage: $alertMessage, ringState: $ringState)
        }
    }
}
