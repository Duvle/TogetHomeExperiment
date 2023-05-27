//
//  KeyboardExtension.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/05/27.
//

import Foundation
import SwiftUI
 
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
