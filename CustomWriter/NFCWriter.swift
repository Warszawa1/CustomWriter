//
//  NFCWriter.swift
//  CustomWriter
//
//  Created by Ire  Av on 15/4/25.
//


import SwiftUI
import CoreNFC

class NFCWriter: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var message = "Ready to write"
    @Published var isWriting = false
    
    private var session: NFCNDEFReaderSession?
    
    func writeURLForBackgroundReading(_ url: URL) {
        // Instead of writing a URL, we'll create a custom MIME record
        guard NFCNDEFReaderSession.readingAvailable else {
            message = "NFC not available on this device"
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near an NFC tag to write"
        session?.begin()
        
        isWriting = true
        message = "Scanning for tag..."
    }
    
    // Optional but recommended delegate method
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        DispatchQueue.main.async {
            self.message = "Scanning active. Hold near a tag."
        }
    }
    
    // Required delegate method when session is invalidated
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.isWriting = false
            
            // If we recently had a success, don't show the session invalidated message
            if let timestamp = UserDefaults.standard.object(forKey: "lastSuccessTimestamp") as? Date,
               Date().timeIntervalSince(timestamp) < 2.0,
               error.localizedDescription.contains("invalidated") {
                // Don't update the message, keep showing success
                return
            }
            
            if error.localizedDescription.contains("Canceled") {
                self.message = "Ready to write"
            } else if !error.localizedDescription.contains("invalidated") {
                // Only show actual errors, not the normal session invalidation
                self.message = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    // Required delegate method when NDEF messages are detected
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // This method is required by the protocol even though we're using didDetect tags for writing
        // We can leave it empty since we're not using this for our functionality
    }
    
    // Method to handle tag detection for writing
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        // Get the first tag
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "No valid tag found")
            return
        }
        
        // Connect to the tag
        session.connect(to: tag) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                session.invalidate(errorMessage: "Connection error: \(error.localizedDescription)")
                return
            }
            
            // Check tag capabilities
            tag.queryNDEFStatus { status, capacity, error in
                if let error = error {
                    session.invalidate(errorMessage: "Query error: \(error.localizedDescription)")
                    return
                }
                
                switch status {
                case .notSupported:
                    session.invalidate(errorMessage: "Tag doesn't support NDEF")
                case .readOnly:
                    session.invalidate(errorMessage: "Tag is read-only")
                case .readWrite:
                    // Create both records on the same tag
                    let urlRecord = NFCNDEFPayload.wellKnownTypeURIPayload(url: URL(string: "presentcup://focus")!)!

                    let mimeType = "application/com.ireav.present"
                    let mimePayload = "toggle_focus".data(using: .utf8)!
                    let mimeRecord = NFCNDEFPayload(
                        format: .media,
                        type: mimeType.data(using: .utf8)!,
                        identifier: Data(),
                        payload: mimePayload
                    )

                    // Create message with both records
                    let message = NFCNDEFMessage(records: [urlRecord, mimeRecord])
                    
                    // Write the message to the tag
                    tag.writeNDEF(message) { error in
                        if let error = error {
                            session.invalidate(errorMessage: "Write failed: \(error.localizedDescription)")
                        } else {
                            session.alertMessage = "Successfully wrote to tag for your app!"
                            session.invalidate()
                            
                            DispatchQueue.main.async {
                                self.message = "Successfully wrote the NFC tag!"
                                UserDefaults.standard.set(Date(), forKey: "lastSuccessTimestamp")
                            }
                        }
                    }
                @unknown default:
                    session.invalidate(errorMessage: "Unknown tag status")
                }
            }
        }
    }
}
