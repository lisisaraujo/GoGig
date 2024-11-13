//
//  Colors.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI


extension View {
  func monochromed(color: Color, colorScheme: ColorScheme = .dark) -> some View {
    let filter: some View = color
      .blendMode(.color)
      .opacity(0.5)
      .allowsHitTesting(false)
    
    return self
      .preferredColorScheme(colorScheme)
      .tint(color)
      .overlay {
        filter
          .ignoresSafeArea()
      }
      .colorMultiply(color)
  }
}
