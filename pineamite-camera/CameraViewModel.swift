//
//  CameraViewModel.swift
//  pineamite-camera
//
//  Created by Ibraiz Qazi on 11/15/25.
//

import SwiftUI
import AVFoundation
import Photos

class CameraViewModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    @Published var videoUploadCounter = 0
    @Published var isRecording = false
    @Published var isAuthorized = false
    @Published var setupError: String?
    
    private var movieOutput : AVCaptureMovieFileOutput?
    private var outputURL: URL?
    
    override init() {
        super.init()
        checkAuthorization()
    }
    
    private func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted {
                        self?.configureSession()
                    }
                }
            }
        case .denied, .restricted:
            isAuthorized = false
            setupError = "Camera access denied"
        @unknown default:
            isAuthorized = false
            setupError = "Unknown authorization status"
        }
    }
    
    private func configureSession() {
        // Run on background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.session.beginConfiguration()
            
            // Set preset before adding inputs
            if self.session.canSetSessionPreset(.high) {
                self.session.sessionPreset = .high
            }
            
            // Camera input
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                DispatchQueue.main.async {
                    self.setupError = "No camera device found"
                }
                self.session.commitConfiguration()
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                } else {
                    DispatchQueue.main.async {
                        self.setupError = "Cannot add camera input"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.setupError = "Camera input error: \(error.localizedDescription)"
                }
            }
            
            // Microphone
            if let mic = AVCaptureDevice.default(for: .audio) {
                do {
                    let micInput = try AVCaptureDeviceInput(device: mic)
                    if self.session.canAddInput(micInput) {
                        self.session.addInput(micInput)
                    }
                } catch {
                    print("Microphone error: \(error.localizedDescription)")
                }
            }
            
            // Movie output
            let output = AVCaptureMovieFileOutput()
            if self.session.canAddOutput(output) {
                self.session.addOutput(output)
                
                // Configure video stabilization if available
                if let connection = output.connection(with: .video) {
                    if connection.isVideoStabilizationSupported {
                        connection.preferredVideoStabilizationMode = .auto
                    }
                }
                
                self.movieOutput = output
            }
            
            self.session.commitConfiguration()
            
            // Start the session
            self.session.startRunning()
        }
    }
    
    func startRecording() {
        guard !isRecording, let movieOutput = movieOutput else { return }
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("video_\(UUID().uuidString).mov")
        self.outputURL = url
        
        movieOutput.startRecording(to: url, recordingDelegate: self)
        isRecording = true
    }
    
    func stopRecording() {
        guard isRecording, let movieOutput = movieOutput else { return }
        movieOutput.stopRecording()
    }
    
    deinit {
        if session.isRunning {
            session.stopRunning()
        }
    }
}

extension CameraViewModel: AVCaptureFileOutputRecordingDelegate {
    nonisolated func fileOutput(_ output: AVCaptureFileOutput,
                                didFinishRecordingTo outputFileURL: URL,
                                from connections: [AVCaptureConnection],
                                error: Error?) {
        
        if let error = error {
            print("Recording error: \(error.localizedDescription)")
        }
        
        Task { @MainActor in
            await saveVideo(at: outputFileURL)
        }
    }
    
    @MainActor
    private func saveVideo(at url: URL) async {
        // Save to Photos
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                DispatchQueue.main.async {
                    self.videoUploadCounter += 1
                    self.isRecording = false
                }
                
                // Clean up temp file
                try? FileManager.default.removeItem(at: url)
            } else if let error = error {
                print("Save error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }
    }
}
