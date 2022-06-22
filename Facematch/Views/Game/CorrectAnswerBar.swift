//
//  CorrectAnswerBar.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/29/21.
//

import SwiftUI

struct CorrectAnswerBar: View {
    let answer: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text("CORRECT ANSWER")
                .font(.appBarTitle)
            Text(answer)
                .font(.appBarSubtitle)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 50)
        .background(Color.appItemBackground)
        .cornerRadius(10)
    }
}

struct CorrectAnswerBar_Previews: PreviewProvider {
    static var previews: some View {
        CorrectAnswerBar(answer: "Barbora")
    }
}
