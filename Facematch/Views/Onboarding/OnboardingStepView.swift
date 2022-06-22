//
//  OnboardingStepView.swift
//  Facematch
//
//  Created by Nick Beresnev on 4/1/21.
//

import SwiftUI

struct OnboardingStepView: View {
    let image: Image
    let titleText: String
    let descriptionText: String
    
    var body: some View {
        VStack {
            image
                .resizable()
                .frame(maxWidth: 119, maxHeight: 119)
                .aspectRatio(contentMode: .fit)
            
            Spacer()
                .frame(height: 45)
            
            Text(titleText)
                .font(.appLargeTitle)
            
            Spacer()
                .frame(height: 32)
            
            Text(descriptionText)
                .font(.appLeaderboardPosition)
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextThird)
        }
        .padding(.horizontal, 40)
    }
}

struct OnboardingStepView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStepView(
            image: Image("strvLogo"),
            titleText: "Hi, Frantisek",
            descriptionText: "Meeting new people in short time can be tough. We made app to ease the pain."
        )
    }
}
