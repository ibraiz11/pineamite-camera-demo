//
//  CameraScreen.swift
//  pineamite-camera
//
//  Created by Ibraiz Qazi on 11/15/25.


import SwiftUI
import AVFoundation

struct CameraScreen: View {
    @StateObject private var cameraVM = CameraViewModel()
    @StateObject private var orientationManager = OrientationManager()
    
    @State private var uploadCount: Int = 0
    
    @State private var isRecording = false
    @State private var selectedZoom = 1
    @State private var saveToDevice = false
    @State private var handMode: HandMode = .single
    
    enum HandMode {
        case single
        case double
    }
    
    var body: some View {
        
        GeometryReader { geo in
            let orientation = ScreenOrientation(device: orientationManager.orientation)
            
            VStack(spacing: 0) {
                ZStack {
                    
                    CameraPreview(session: cameraVM.session)
                        .ignoresSafeArea(edges: .all)
                        .frame(height: geo.size.height - (80 + geo.safeAreaInsets.bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .zIndex(0)
                    
                    // Close button in top-left (auto rotates & stays pinned)
                    CloseButton(orientation: orientation)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                    
                    // Top-right controls (auto rotate)
                    TopRightControls(orientation: orientation, uploadCount: $cameraVM.videoUploadCounter)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    
                    
                    VStack {
                        HStack {
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    handMode = handMode == .single ? .double : .single
                                }
                            }) {
                                Text(handMode == .single ? "Single Hand" : "Two Hands")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Capsule())
                            }
                            .padding(.trailing, 16)
                            .padding(.top, 16)
                        }
                    }
                    
                    // Main center controls (fixed now)
                    MainCenterControls(
                        cameraVM: cameraVM,
                        isRecording: $isRecording,
                        selectedZoom: $selectedZoom,
                        handMode: handMode,
                        orientation: orientation
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    
                }
                
                // Bottom Menu
                BottomMenu(
                    saveToDevice: $saveToDevice,
                    orientation: orientation
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, geo.safeAreaInsets.bottom)
                .padding(.horizontal, 20)
            }
//            .ignoresSafeArea(edges: .vertical)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: orientation)

        }
    }
}

// MARK: - Close Button
struct CloseButton: View {
    let orientation: ScreenOrientation
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
        .rotationEffect(.degrees(orientation.rotation))
    }
}

// MARK: - Top Right Controls
struct TopRightControls: View {
    let orientation: ScreenOrientation
    @Binding var uploadCount: Int
    
    var body: some View {
        VStack(spacing: 12) {
            
            ZStack {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Text("\(uploadCount)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .offset(x: 8, y: 16)
            }
            
            Button(action: {}) {
                Text("SS2")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.8))
                    .frame(width: 36, height: 36)
                    .background(Color.gray.opacity(0.7))
                    .clipShape(Circle())
            }
        }
        .padding(.leading, 10)
        .rotationEffect(.degrees(orientation.rotation))
    }
}

// MARK: - Main Center Controls
struct MainCenterControls: View {
    @ObservedObject var cameraVM: CameraViewModel
    @Binding var isRecording: Bool
    @Binding var selectedZoom: Int
    let handMode: CameraScreen.HandMode
    let orientation: ScreenOrientation
    
    var body: some View {
//        if !orientation.isLandscape {
        if handMode == .double {
            twoHandControls
        } else {
            portraitControls
        }
//        } else if handMode == .single {
//            singleHandLandscapeControls
//        } else {
//            twoHandLandscapeControls
//        }
    }
    
    private var portraitControls: some View {
        VStack(alignment: .center, spacing: 30) {
            
            zoomButtons
            
            HStack(alignment: .center, spacing: 16) {
                settingsButton
                    .rotationEffect(.degrees(orientation.rotation))
                recordButton
                    .rotationEffect(.degrees(orientation.rotation))
                cameraButton
                    .rotationEffect(.degrees(orientation.rotation))
            }
        }
//        .rotationEffect(.degrees(orientation.rotation))
    }
 
    private var singleHandLandscapeControls: some View {
        VStack(spacing: 240) {
           
            zoomButtons
            
            HStack(alignment: .center, spacing: 16) {
                settingsButton
                recordButton
                cameraButton
            }
            
        }
//        .rotationEffect(.degrees(orientation.rotation))
    }
    
    // MARK: - Two Hands Landscape Layout
    private var twoHandControls: some View {
        VStack(alignment: .center, spacing: 440) {
            
            zoomButtons
                        
            HStack(alignment: .center, spacing: 16) {
                settingsButton
                    .rotationEffect(.degrees(orientation.rotation))
                recordButton
                    .rotationEffect(.degrees(orientation.rotation))
                cameraButton
                    .rotationEffect(.degrees(orientation.rotation))
            }
        }
    }
    
    private var recordButton: some View {
        Button(action: {
            if cameraVM.isRecording {
                cameraVM.stopRecording()
            } else {
                cameraVM.startRecording()
            }
        }) {
            ZStack {
                
                // OUTER RING (pulses when recording)
                Circle()
                    .stroke(
                        cameraVM.isRecording ? Color.red.opacity(0.6) : Color.red.opacity(0.4),
                        lineWidth: cameraVM.isRecording ? 6 : 4
                    )
                    .frame(width: cameraVM.isRecording ? 78 : 64,
                           height: cameraVM.isRecording ? 78 : 64)
                    .scaleEffect(cameraVM.isRecording ? 1.12 : 1.0)
                    .animation(.easeInOut(duration: 0.28), value: cameraVM.isRecording)
                
                // MIDDLE CIRCLE (the original red fill)
                Circle()
                    .fill(Color.red)
                    .frame(width: cameraVM.isRecording ? 64 : 60,
                           height: cameraVM.isRecording ? 64 : 60)
                    .opacity(cameraVM.isRecording ? 0.8 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7),
                               value: cameraVM.isRecording)
                
                // INNER SHAPE (circle → rounded square)
                RoundedRectangle(cornerRadius: cameraVM.isRecording ? 8 : 24)
                    .fill(Color.red)
                    .frame(width: cameraVM.isRecording ? 32 : 48,
                           height: cameraVM.isRecording ? 32 : 48)
                    .animation(.spring(response: 0.35, dampingFraction: 0.75),
                               value: cameraVM.isRecording)
            }
        }
    }

    
//    private var recordButton: some View {
//        Button(action: {
//            isRecording.toggle()
//            cameraVM.isRecording ? cameraVM.stopRecording() : cameraVM.startRecording()
//        }) {
//            ZStack {
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 60, height: 60)
//                
//                Circle()
//                    .stroke(Color.red.opacity(0.4), lineWidth: 4)
//                    .frame(width: 64, height: 64)
//                
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 48, height: 48)
//            }
//        }
//    }
    
    private var settingsButton: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16))
                Text("Settings")
                    .font(.system(size: 14, weight: .medium))
            }
            .frame(width: 86, height: 32, alignment: .center)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(Color.black.opacity(0.7))
            .clipShape(Capsule())
        }
    }
    
    private var cameraButton: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 16))
                Text("24mm")
                    .font(.system(size: 14, weight: .medium))
            }
            .frame(width: 86, height: 32, alignment: .center)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(Color.black.opacity(0.7))
            .clipShape(Capsule())
        }
    }
    
    private var zoomButtons: some View {
        HStack(spacing: 12) {
            ForEach([1, 2, 5], id: \.self) { zoom in
                Button(action: { selectedZoom = zoom }) {
                    Text("\(zoom)x")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.black.opacity(selectedZoom == zoom ? 0.7 : 0.5))
                        .clipShape(Circle())
                        .rotationEffect(.degrees(orientation.rotation))
                }
            }
        }
    }
}

// MARK: - Bottom Menu
struct BottomMenu: View {
    @Binding var saveToDevice: Bool
    let orientation: ScreenOrientation
    
    var body: some View {
//        if orientation.isLandscape {
//            landscapeMenu
//        } else {
            portraitMenu
//        }
    }
    // MARK: - Landscape Menu (Side Menu)
    private var landscapeMenu: some View {
        VStack(spacing: 32) {
            UploadItem
            SaveToggle
            LiveButton
        }
//        .rotationEffect(.degrees(orientation.rotation))
        .padding(.leading, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    // MARK: - Portrait Menu (Bottom Menu)
    private var portraitMenu: some View {
        HStack {
            UploadItem
                .rotationEffect(.degrees(orientation.rotation))
            Spacer()
            SaveToggle
                .rotationEffect(.degrees(orientation.rotation))
            Spacer()
            LiveButton
                .rotationEffect(.degrees(orientation.rotation))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.black)
//        .rotationEffect(.degrees(orientation.rotation))
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    private var UploadItem: some View {
        VStack {
            Text("Upload Media").foregroundColor(.white).font(.system(size: 11))
            Image(systemName: "square.and.arrow.up").foregroundColor(.white).font(.system(size: 22))
        }
    }
    
    private var SaveToggle: some View {
        VStack {
            Text("Save to Device")
                .font(.system(size: 11))
                .foregroundColor(saveToDevice ? .white : .gray)
            Toggle("", isOn: $saveToDevice)
                .labelsHidden()
                .scaleEffect(0.8)
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 44, green: 0, blue: 133)))
        }
    }
    
    private var LiveButton: some View {
        Button { } label: {
            Image("ic-live")
                .resizable()
                .scaledToFill()
                .frame(width: 46, height: 46)
        }
    }
    
}

struct CapsuleButton: View {
    let icon: String
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
            Text(label)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .foregroundColor(.white)
        .background(Color.black.opacity(0.7))
        .clipShape(Capsule())
        .frame(height: 36)
    }
}

// MARK: - Preview
struct CameraScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CameraScreen()
                .previewInterfaceOrientation(.portrait)
                .previewDisplayName("Portrait")
            
            CameraScreen()
                .previewInterfaceOrientation(.portraitUpsideDown)
                .previewDisplayName("Portrait Upside Down")
            
            CameraScreen()
                .previewInterfaceOrientation(.landscapeRight)
                .previewDisplayName("Landscape Right")
            
            CameraScreen()
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Landscape Left")
        }
    }
}
