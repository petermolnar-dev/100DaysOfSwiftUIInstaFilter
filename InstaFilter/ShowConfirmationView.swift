//
//  ShowConfirmationView.swift
//  InstaFilter
//
//  Created by Peter Molnar on 14/04/2022.
//

import SwiftUI

struct ShowConfirmationView: View {
    @State private var showConfirmation = false
    @State private var backgroundColor = Color.white
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture {
                showConfirmation = true
            }
            .confirmationDialog("Change background", isPresented: $showConfirmation) {
                Button("Red") { backgroundColor = .red }
                Button("Green") { backgroundColor = .green }
                Button("Blue") { backgroundColor = .blue }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Select a new color")
            }
    }
}

struct ShowConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ShowConfirmationView()
    }
}
