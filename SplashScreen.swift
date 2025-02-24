//
//  SplashScreen.swift
//  SmartBites
//
//  Created by Yash's Mackbook on 23/02/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var opacity = 0.3
    
    var body: some View {
        if isActive {
            OnboardingView()  // ✅ Navigate to Onboarding after splash
        } else {
            ZStack {
                // 🌅 Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.7), Color.orange.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(systemName: "leaf.fill")  // Replace with your logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.5)) {
                                self.opacity = 1.0
                            }
                        }
                    
                    Text("SmartBites 🍏")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {  // ⏳ Delay before navigating
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
