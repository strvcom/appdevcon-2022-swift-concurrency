//
//  AnimatedSyncingView.swift
//  Facematch
//
//  Created by Abel Osorio on 1/7/21.
//

import SwiftUI

struct AnimatedSyncingView: View {
    static let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        
        return formatter
    }()
    
    @State var text = "Looking for new arrivals"
    @State var lastShownImageIndex = 0
    @State var imagesOnScreen = 0
    
    let progress: Double
    let syncedImageURLs: [URL]
    
    let texts = [
        "Updating old timers",
        "Picking your best angle",
        "Shuffling all the folks"
    ]

    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var progressPercentage: String {
        Self.percentageFormatter.string(from: progress as NSNumber) ?? ""
    }
    
    var imagesToShow: [URL] {
        return Array(syncedImageURLs[safe: lastShownImageIndex..<lastShownImageIndex + imagesOnScreen + 1])
    }
        
    var body: some View {
        Group {
            ZStack(alignment: .center) {
                ForEach(imagesToShow, id: \.self) { image in
                    let index = syncedImageURLs.firstIndex(of: image) ?? 0
                    
                    AnimatedSyncImageView(
                        url: image,
                        position: index % 2 == 0 ? .top : .bottom
                    ) {
                        lastShownImageIndex += 1
                        imagesOnScreen -= 1
                    }
                    .onAppear {
                        // It's supposed to be shown on the screen after a bit.
                        // So we dispatch `onAppearOnScreen` to grab another image
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            imagesOnScreen += 1
                        }
                    }
                }
                
                VStack(spacing: 20) {
                    LoadingIndicator()

                    Text("\(text) \(progressPercentage)")
                        .font(.appTitle)
                        .foregroundColor(.appTextFirst)
                }
                .padding(32)
            }
        }
        .onReceive(timer, perform: timerTick)
    }
}

extension AnimatedSyncingView {
    func timerTick(_: Date) {
        self.text = texts.randomElement() ?? ""
    }
}

struct AnimatedSyncingView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedSyncingView(progress: 0.99, syncedImageURLs: [])
    }
}
