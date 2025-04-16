//
//  ContentView.swift
//  CustomWriter
//
//  Created by Ire  Av on 15/4/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var nfcWriter = NFCWriter()
    @State private var duration = "30"
    @FocusState private var isDurationFocused: Bool
    
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
                    
                    // Flexible space between icon and duration
                    Spacer()
                        .frame(height: geometry.size.height * 0.12)
                    
                    // Duration field
                    VStack(spacing: 15) {
                        Text("Session Duration")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            TextField("30", text: $duration)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 100)
                                .focused($isDurationFocused)
                            
                            Text("minutes")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Status message
                    Spacer()
                        .frame(height: geometry.size.height * 0.08)
                    
                    Text(nfcWriter.message)
                        .font(.headline)
                        .foregroundColor(nfcWriter.message.contains("Success") ? .green : .gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Flexible space before button
                    Spacer()
                        .frame(height: geometry.size.height * 0.15)
                    
                    // Write button
                    Button(action: {
                        hideKeyboard()
                        let urlString = "presentcup://focus?location=cafe&duration=\(duration)"
                        if let url = URL(string: urlString) {
                            nfcWriter.writeURLForBackgroundReading(url)  // Make sure this method exists in your NFCWriter class
                        }
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
        .onTapGesture {
            hideKeyboard()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }
            }
        }
    }
    
    private func hideKeyboard() {
        isDurationFocused = false
    }
}
 
#Preview {
    ContentView()
}
