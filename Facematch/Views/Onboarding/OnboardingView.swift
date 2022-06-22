//
//  OnboardingView.swift
//  Facematch
//
//  Created by Nick Beresnev on 4/1/21.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appStore: AppStore
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    @State var selectedStep = 0
    
    var buttonTitle: String {
        isLastStep
            ? "EXPLORE APP"
            : "NEXT"
    }
    
    var isLastStep: Bool {
        onboardingStore.steps[safe: selectedStep] == OnboardingStep.step4
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Image("strvLogo")
            
            Spacer()
            
            TabView(selection: $selectedStep) {
                ForEach(onboardingStore.steps) { step in
                    let index = onboardingStore.steps.firstIndex(of: step)
                    
                    OnboardingStepView(
                        image: step.image,
                        titleText: step.title,
                        descriptionText: step.description
                    )
                    .id(index)
                }
            }
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .always)
            )
            
            Spacer()
            
            Button(action: nextTapped) {
                Text(buttonTitle)
            }
            .buttonStyle(
                OnboardingButtonStyle(
                    isLastStep: isLastStep
                )
            )
        }
        .padding()
        .background(Color.appBackground.edgesIgnoringSafeArea(.all))
        .onAppear {
            onboardingStore.updateSteps()
        }
    }
}

private extension OnboardingView {
    func nextTapped() {
        guard !isLastStep else {
            appStore.hasSeenOnboarding = true
            presentationMode.wrappedValue.dismiss()
            
            return
        }
        
        selectedStep += 1
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView()
            OnboardingView().colorScheme(.dark)
        }
    }
}
