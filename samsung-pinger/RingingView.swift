//
//  RingingView.swift
//  samsung-pinger
//
//  Created by Виктор Щелочков on 29.09.2023.
//

import SwiftUI

struct RingingView: View {
    @ObservedObject var windowState: WindowState
    
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var ringState: String

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
            
            VStack {
                Text(ringState == "connecting" ? "Connecting..." : "Ringing your Samsung device...")
                    .foregroundColor(Color.white)
                    .font(.custom("Samsung Sharp Sans", size: 20))
                    .fontWeight(Font.Weight.medium)
            }
        }
        .frame(width: 400, height: 300)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
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
            RingingView(windowState: WindowState(), showAlert: $isShowingAlert, alertMessage: $alertMessage, ringState: $ringState)
        }
    }
}
