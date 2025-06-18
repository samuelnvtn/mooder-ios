//
//  SplashView.swift
//  Mooder
//
//  Created by Samuel Novotný on 18.06.2025.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 191/255, green: 212/255, blue: 240/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 8) {
                VStack(alignment: .center, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("MO")
                        Image(systemName: "face.smiling")
                        Text("DER")
                    }
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("your")
                        Text("mood")
                        Text("tracker.")
                    }
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    SplashView()
}
