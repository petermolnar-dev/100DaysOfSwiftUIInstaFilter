//
//  ContentView.swift
//  InstaFilter
//
//  Created by Peter Molnar on 29/04/2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                   showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        // Change filter
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                }
            }
        }
        .padding([.horizontal, .bottom])
        .navigationTitle("Instafilter")
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(image: $inputImage)
        })
        .onChange(of: inputImage) { _ in
            loadImage()
        }
    }
    
    // MARK: - Helper functions
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        image = Image(uiImage: inputImage)
    }
    
    func save() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
