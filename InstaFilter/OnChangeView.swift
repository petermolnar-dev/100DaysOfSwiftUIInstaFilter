//
//  OnChangeView.swift
//  InstaFilter
//
//  Created by Peter Molnar on 14/04/2022.
//

import SwiftUI

struct OnChangeView: View {
    @State private var blurAmount = 0.0
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 1...20)
                .onChange(of: blurAmount) { newBlurAmount in
                    print("Blur amount: \(newBlurAmount)")
                }
            
            Button("Random blur")  {
                blurAmount = Double.random(in: 1...20)
            }
        }
      
    }
}

struct OnChangeView_Previews: PreviewProvider {
    static var previews: some View {
        OnChangeView()
    }
}
