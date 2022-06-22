//
//  FacematchLogoView.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 2/22/21.
//

import SwiftUI

struct FacematchLogoView: View {
    @State private var showCursor = true

    let timer = Timer.publish(every: 0.75, on: .current, in: .common).autoconnect()

    var body: some View {
        HStack(alignment: .bottom) {
            Image("Login/Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 242, height: 209)
            
            Rectangle()
                .fill(showCursor ? Color.accentColor : Color.appBackground)
                .frame(width: 7, height: 100)
                .offset(x: -40, y: -8)
        }
        .onReceive(timer, perform: timerTick)
    }
    
    func timerTick(_: Date) {
        showCursor.toggle()
    }
}

struct FacematchLogoView_Previews: PreviewProvider {
    static var previews: some View {
        FacematchLogoView()
    }
}
