//
//  View + Extension.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 07/04/2025.
//

import SwiftUI

extension View {
    
    func isHidden(_ isHidden: Bool) -> Self? {
        isHidden ? nil : self
    }
}
