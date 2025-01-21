//
//  PulseAnimation.swift
//  SolarDatePicker
//
//  Created by HEssam on 1/21/25.
//

import SwiftUI

struct PulseAnimation: View {
    @State var enablePulse = false
    
    var imageResource: ImageResource

    var body: some View {
        Image(imageResource)
            .resizable()
            .frame(width: 120, height: 120)
            .opacity(enablePulse ? 0 : 0.3)
            .scaleEffect(enablePulse ? 1.5 : 1)
            .onAppear {
                withAnimation(.linear(duration: 3.0)) {
                    enablePulse = true
                }
            }
    }
}

struct PulseModel: Identifiable {
    var id = UUID()
}


#Preview {
    PulseAnimation(imageResource: .sun)
}
