//
//  ContentView.swift
//  InstaFilter
//
//  Created by Peter Molnar on 10/04/2022.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins



class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

struct ContentViewPlayground: View {
    
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            Button("Select image") {
                showImagePicker = true
            }
            .padding()
            Button("Save Image") {
                guard let inputImage = inputImage else {
                    return
                }

                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: inputImage)
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in
            loadImage()
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        image = Image(uiImage: inputImage)
    }
    
    func loadImageFromExample() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.twirlDistortion()
        
        currentFilter.inputImage = beginImage
        // To make the filter setup flexible:
        
        let amount = 1.0
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(amount, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) {currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        
        // Get a CIImage (Image recipe) from the filter. It might fail:
        guard let outputImage = currentFilter.outputImage else { return }
        
        // Attempt to get a CGIMage from the CIImage. Might fail.
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            // Convert to UIImage
            let uiImage = UIImage(cgImage: cgimg)
            
            // Then back to SwiftUI Image :O
            image = Image(uiImage: uiImage)
        }
    }
    
    private func makeSepiaFilter(beginImage: CIImage?) -> CIFilter {
        let currentFilter = CIFilter.sepiaTone()
        
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        return currentFilter
    }
    
    private func makePixelateFilter(beginImage: CIImage?) -> CIFilter {
        let currentFilter = CIFilter.pixellate()
        
        currentFilter.inputImage = beginImage
        currentFilter.scale = 100
        
        return currentFilter
    }
    
    private func makeCrystallizeFilter(beginImage: CIImage?) -> CIFilter {
        let currentFilter = CIFilter.crystallize()
        
        currentFilter.inputImage = beginImage
        currentFilter.radius = 200
        
        return currentFilter
    }
    
    private func makeTwirlDistortionFilter(beginImage: CIImage?) -> CIFilter {
        let currentFilter = CIFilter.twirlDistortion()
        
        currentFilter.inputImage = beginImage
        currentFilter.radius = 1000
        currentFilter.center = CGPoint(x: (beginImage?.extent.width ?? 100) / 2, y: (beginImage?.extent.height ?? 100) / 2)
        
        return currentFilter
    }
}

struct ContentViewPlaygroundPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
