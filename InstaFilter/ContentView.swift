//
//  ContentView.swift
//  InstaFilter
//
//  Created by Peter Molnar on 29/04/2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum ViewVisibility: CaseIterable {
    case visible, // view is fully visible
         invisible, // view is hidden but takes up space
         gone // view is fully removed from the view hierarchy
}

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 100.0
    @State private var filterScale = 10.0
    
    
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingFilterSheet = false
    
    @State private var showIntensity: ViewVisibility = .gone
    @State private var showRadius: ViewVisibility = .gone
    @State private var showScale: ViewVisibility = .gone
    
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
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
                        .onChange(of: filterIntensity) { _ in
                            applyProcessing()
                        }
                        .disabled(inputImage == nil)
                        .id(inputImage)
                    
                }
                .padding(.vertical)
                .visibility(showIntensity)
                
                HStack {
                    Text("Radius")
                    Slider(value: $filterRadius)
                        .onChange(of: filterRadius) { _ in
                            applyProcessing()
                        }
                        .disabled(inputImage == nil)
                        .id(inputImage)
                }
                .padding(.vertical)
                .visibility(showRadius)
                
                HStack {
                    Text("Scale")
                    Slider(value: $filterScale)
                        .onChange(of: filterScale) { _ in
                            applyProcessing()
                        }
                        .disabled(inputImage == nil)
                        .id(inputImage)
                }
                .padding(.vertical)
                .visibility(showScale)
                
                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(inputImage == nil)
                }
            }
        }
        .padding([.horizontal, .bottom])
        .navigationTitle("Instafilter")
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(image: $inputImage)
        })
        .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
            Button("Crystallize") { setFilter(CIFilter.crystallize()) }
            Button("Edges") { setFilter(CIFilter.edges()) }
            Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
            Button("Pixellate") { setFilter(CIFilter.pixellate()) }
            Button("Sepia tone") { setFilter(CIFilter.sepiaTone()) }
            Button("Unsharp mask") { setFilter(CIFilter.unsharpMask()) }
            Button("Vignette") { setFilter(CIFilter.vignette()) }
            
            Button("Cancel", role: .cancel) { }
        }
        .onChange(of: inputImage) { _ in
            loadImage()
        }
    }
    
    // MARK: - Helper functions
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func save() {
        guard let processedImage = processedImage else {
            return
        }
        
        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            print("Image completed")
        }
        
        imageSaver.errorHandler = { error in
            print("Oops, an error happened: \(error)")
        }
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                showIntensity = .visible
            }
        } else {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                showIntensity = .gone
            }
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                showRadius = .visible
            }
        } else {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                showRadius = .gone
            }
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                showScale = .visible
            }
        } else {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                showScale = .gone
            }
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
}


extension View {
    @ViewBuilder func visibility(_ visibility: ViewVisibility) -> some View {
        if visibility != .gone {
            if visibility == .visible {
                self
            } else {
                hidden()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
