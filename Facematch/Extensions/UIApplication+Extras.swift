//
//  UIApplication+Extras.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 2/11/21.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
