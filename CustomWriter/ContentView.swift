//
//  ContentView.swift
//  CustomWriter
//
//  Created by Ire  Av on 15/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var nfcWriter = NFCWriter()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    // Top space
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    
                    // Title
                    Text("Custom Writer")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Flexible space between title and icon
                    Spacer()
                        .frame(height: geometry.size.height * 0.12)
                    
                    // NFC Icon - centered
                    Image(systemName: "radiowaves.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.blue)
                    
                    // Status message
                    Spacer()
                        .frame(height: geometry.size.height * 0.2)
                    
                    Text(nfcWriter.message)
                        .font(.headline)
                        .foregroundColor(nfcWriter.message.contains("Success") ? .green : .gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Flexible space before button
                    Spacer()
                        .frame(height: geometry.size.height * 0.2)
                    
                    // Write button
                    Button(action: {
                        let url = URL(string: "presentcup://focus")!
                        nfcWriter.writeURLForBackgroundReading(url)
                    }) {
                        Text("Write to NFC Tag")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                    
                    // Bottom space
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ContentView()
}

