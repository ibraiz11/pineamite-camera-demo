//
//  RecordingScreen.swift
//  pineamite-camera
//
//  Created by Ibraiz Qazi on 11/15/25.
//
//
//
//import SwiftUI
//import AVFoundation
//
//struct RecordingScreen: View {
//    @StateObject private var cameraVM = CameraViewModel()
//    @StateObject private var orientationManager = OrientationManager()
//    
//    @State private var isRecording = false
//    @State private var selectedZoom = 1
//    @State private var saveToDevice = false
//    @State private var handMode: HandMode = .single
//    
//    enum HandMode {
//        case single
//        case double
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let currentOrientation = validOrientation(orientationManager.orientation)
//            let isLandscape = currentOrientation.isLandscape
//            let isLandscapeLeft = currentOrientation == .landscapeLeft
//            let isPortraitUpsideDown = currentOrientation == .portraitUpsideDown
//            
//            ZStack {
//                // Camera Preview with Controls
//                ZStack {
//                    CameraPreview(session: cameraVM.session)
//                    
//                    // Debug Hand Mode Toggle
//                    VStack {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                                    handMode = handMode == .single ? .double : .single
//                                }
//                            }) {
//                                Text(handMode == .single ? "Single Hand" : "Two Hands")
//                                    .font(.system(size: 12, weight: .semibold))
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 12)
//                                    .padding(.vertical, 6)
//                                    .background(Color.black.opacity(0.6))
//                                    .clipShape(Capsule())
//                            }
//                            .padding(.trailing, 16)
//                            .padding(.top, 16)
//                        }
//                        Spacer()
//                    }
//                    
//                    // Close Button
//                    CloseButton(
//                        isLandscape: isLandscape,
//                        isLandscapeLeft: isLandscapeLeft,
//                        isPortraitUpsideDown: isPortraitUpsideDown,
//                        geometry: geometry
//                    )
//                    
//                    // Top Right Controls
//                    TopRightControls(
//                        isLandscape: isLandscape,
//                        isLandscapeLeft: isLandscapeLeft,
//                        isPortraitUpsideDown: isPortraitUpsideDown,
//                        geometry: geometry
//                    )
//                    
//                    // Main Center Controls
//                    MainCenterControls(
//                        isRecording: $isRecording,
//                        selectedZoom: $selectedZoom,
//                        handMode: handMode,
//                        isLandscape: isLandscape,
//                        isLandscapeLeft: isLandscapeLeft,
//                        isPortraitUpsideDown: isPortraitUpsideDown,
//                        geometry: geometry
//                    )
//                }
//                .clipShape(RoundedRectangle(cornerRadius: 24))
//                
//                // Bottom Menu (Sticky)
//                BottomMenu(
//                    saveToDevice: $saveToDevice,
//                    isLandscape: isLandscape,
//                    isLandscapeLeft: isLandscapeLeft,
//                    isPortraitUpsideDown: isPortraitUpsideDown,
//                    geometry: geometry
//                )
//            }
//        }
//    }
//    
//    // Helper to get valid orientation, filtering out invalid states
//    private func validOrientation(_ orientation: UIDeviceOrientation) -> UIDeviceOrientation {
//        switch orientation {
//        case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
//            return orientation
//        case .faceUp, .faceDown, .unknown:
//            // Return last valid orientation or default to portrait
//            return .portrait
//        @unknown default:
//            return .portrait
//        }
//    }
//}
//
//// MARK: - Close Button
//struct CloseButton: View {
//    let isLandscape: Bool
//    let isLandscapeLeft: Bool
//    let isPortraitUpsideDown: Bool
//    let geometry: GeometryProxy
//    
//    var body: some View {
//        Button(action: {}) {
//            Image(systemName: "xmark")
//                .font(.system(size: 20, weight: .medium))
//                .foregroundColor(.white)
//                .frame(width: 44, height: 44)
//                .background(Color.black.opacity(0.6))
//                .clipShape(Circle())
//        }
//        .position(
//            x: isLandscape
//            ? (isLandscapeLeft ? geometry.size.width - 48 : 48)
//            : (isPortraitUpsideDown ? geometry.size.width - 48 : 48),
//            y: isLandscape
//            ? geometry.size.height - 48
//            : (isPortraitUpsideDown ? geometry.size.height - 50 : 50)
//        )
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLandscape)
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLandscapeLeft)
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPortraitUpsideDown)
//    }
//}
//
//// MARK: - Top Right Controls
//struct TopRightControls: View {
//    let isLandscape: Bool
//    let isLandscapeLeft: Bool
//    let isPortraitUpsideDown: Bool
//    let geometry: GeometryProxy
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            ZStack(alignment: .topTrailing) {
//                Button(action: {}) {
//                    Image(systemName: "square.and.arrow.up")
//                        .font(.system(size: 18))
//                        .foregroundColor(.white)
//                        .frame(width: 44, height: 44)
//                        .background(Color.black.opacity(0.6))
//                        .clipShape(Circle())
//                }
//                
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 20, height: 20)
//                    .overlay(
//                        Text("0")
//                            .font(.system(size: 11, weight: .bold))
//                            .foregroundColor(.white)
//                    )
//                    .offset(x: 6, y: -6)
//            }
//            
//            Button(action: {}) {
//                Text("SS2")
//                    .font(.system(size: 14, weight: .bold))
//                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.8))
//                    .frame(width: 44, height: 44)
//                    .background(Color.gray.opacity(0.7))
//                    .clipShape(Circle())
//            }
//        }
//        .position(
//            x: isLandscape
//            ? (isLandscapeLeft ? 72 : geometry.size.width - 72)
//            : (isPortraitUpsideDown ? 48 : geometry.size.width - 48),
//            y: isLandscape
//            ? 72
//            : (isPortraitUpsideDown ? geometry.size.height - 80 : 80)
//        )
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLandscape)
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLandscapeLeft)
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPortraitUpsideDown)
//    }
//}
//
//// MARK: - Main Center Controls
//struct MainCenterControls: View {
//    @Binding var isRecording: Bool
//    @Binding var selectedZoom: Int
//    let handMode: RecordingScreen.HandMode
//    let isLandscape: Bool
//    let isLandscapeLeft: Bool
//    let isPortraitUpsideDown: Bool
//    let geometry: GeometryProxy
//    
//    var body: some View {
//        Group {
//            if !isLandscape {
//                portraitLayout
//            } else if handMode == .single {
//                singleHandLandscapeLayout
//            } else {
//                twoHandsLandscapeLayout
//            }
//        }
//    }
//    
//    // MARK: - Portrait Layout
//    private var portraitLayout: some View {
//        VStack(spacing: 40) {
//            // Zoom Buttons (above record button)
//            HStack(spacing: 12) {
//                ForEach([1, 2, 5], id: \.self) { zoom in
//                    zoomButtonPortrait(zoom)
//                }
//            }
//            
//            // Record Button with Side Controls
//            HStack(spacing: 16) {
//                // Settings (left side)
//                settingsButtonPortrait
//                
//                // Record Button (center)
//                recordButtonPortrait
//                
//                // 24mm (right side)
//                cameraButtonPortrait
//            }
//        }
//        .rotationEffect(.degrees(isPortraitUpsideDown ? 180 : 0))
//        .position(
//            x: geometry.size.width / 2,
//            y: geometry.size.height - 240
//        )
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPortraitUpsideDown)
//    }
//    
//    // MARK: - Single Hand Landscape Layout
//    private var singleHandLandscapeLayout: some View {
//        VStack(spacing: 16) {
//            // Top button (changes based on side)
//            if isLandscapeLeft {
//                settingsButtonLandscape
//            } else {
//                cameraButtonLandscape
//            }
//            
//            // Zoom buttons - rotated to stay horizontal for thumb access
//            HStack(spacing: 8) {
//                ForEach(isLandscapeLeft ? [1, 2, 5] : [5, 2, 1], id: \.self) { zoom in
//                    zoomButtonLandscape(zoom)
//                }
//            }
//            .rotationEffect(.degrees(isLandscapeLeft ? 90 : -90))
//            
//            // Record button (center)
//            recordButtonLandscape
//            
//            // Bottom button (changes based on side)
//            if isLandscapeLeft {
//                cameraButtonLandscape
//            } else {
//                settingsButtonLandscape
//            }
//        }
//        .position(
//            x: isLandscapeLeft ? 140 : geometry.size.width - 140,
//            y: geometry.size.height / 2
//        )
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLandscapeLeft)
//    }
//    
//    // MARK: - Two Hands Landscape Layout
//    private var twoHandsLandscapeLayout: some View {
//        ZStack {
//            // Record Button with Settings and 24mm
//            VStack(spacing: 16) {
//                if isLandscapeLeft {
//                    cameraButtonLandscape
//                } else {
//                    settingsButtonLandscape
//                }
//                
//                recordButtonLandscape
//                
//                if isLandscapeLeft {
//                    settingsButtonLandscape
//                } else {
//                    cameraButtonLandscape
//                }
//            }
//            .position(
//                x: isLandscapeLeft ? geometry.size.width - 140 : 140,
//                y: geometry.size.height / 2
//            )
//            
//            // Zoom Buttons on opposite side
//            VStack(spacing: 8) {
//                ForEach(isLandscapeLeft ? [5, 2, 1] : [1, 2, 5], id: \.self) { zoom in
//                    zoomButtonLandscape(zoom)
//                }
//            }
//            .rotationEffect(.degrees(isLandscapeLeft ? 90 : -90))
//            .position(
//                x: isLandscapeLeft ? 80 : geometry.size.width - 80,
//                y: geometry.size.height / 2
//            )
//        }
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLandscapeLeft)
//    }
//    
//    // MARK: - Component Builders - Portrait
//    private var recordButtonPortrait: some View {
//        Button(action: { isRecording.toggle() }) {
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
//    
//    private var settingsButtonPortrait: some View {
//        Button(action: {}) {
//            HStack(spacing: 6) {
//                Image(systemName: "gearshape.fill")
//                    .font(.system(size: 16))
//                Text("Settings")
//                    .font(.system(size: 14, weight: .medium))
//            }
//            .frame(width: 86, height: 32, alignment: .center)
//            .foregroundColor(.white)
//            .padding(.horizontal, 10)
//            .padding(.vertical, 2)
//            .background(Color.black.opacity(0.7))
//            .clipShape(Capsule())
//        }
//    }
//    
//    private var cameraButtonPortrait: some View {
//        Button(action: {}) {
//            HStack(spacing: 6) {
//                Image(systemName: "camera.fill")
//                    .font(.system(size: 16))
//                Text("24mm")
//                    .font(.system(size: 14, weight: .medium))
//            }
//            .frame(width: 86, height: 32, alignment: .center)
//            .foregroundColor(.white)
//            .padding(.horizontal, 10)
//            .padding(.vertical, 2)
//            .background(Color.black.opacity(0.7))
//            .clipShape(Capsule())
//        }
//    }
//    
//    private func zoomButtonPortrait(_ zoom: Int) -> some View {
//        Button(action: { selectedZoom = zoom }) {
//            Text("\(zoom)x")
//                .font(.system(size: 14, weight: .medium))
//                .foregroundColor(.white)
//                .frame(width: 28, height: 28)
//                .background(Color.black.opacity(selectedZoom == zoom ? 0.7 : 0.5))
//                .clipShape(Circle())
//        }
//    }
//    
//    // MARK: - Component Builders - Landscape
//    private var recordButtonLandscape: some View {
//        Button(action: { isRecording.toggle() }) {
//            ZStack {
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 72, height: 72)
//                
//                Circle()
//                    .stroke(Color.red.opacity(0.4), lineWidth: 4)
//                    .frame(width: 80, height: 80)
//                
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 60, height: 60)
//            }
//        }
//    }
//    
//    private var settingsButtonLandscape: some View {
//        Button(action: {}) {
//            HStack(spacing: 6) {
//                Image(systemName: "gearshape.fill")
//                    .font(.system(size: 14))
//                Text("Settings")
//                    .font(.system(size: 13, weight: .medium))
//            }
//            .foregroundColor(.white)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 10)
//            .background(Color.black.opacity(0.7))
//            .clipShape(Capsule())
//        }
//    }
//    
//    private var cameraButtonLandscape: some View {
//        Button(action: {}) {
//            HStack(spacing: 6) {
//                Image(systemName: "camera.fill")
//                    .font(.system(size: 14))
//                Text("24mm")
//                    .font(.system(size: 13, weight: .medium))
//            }
//            .foregroundColor(.white)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 10)
//            .background(Color.black.opacity(0.7))
//            .clipShape(Capsule())
//        }
//    }
//    
//    private func zoomButtonLandscape(_ zoom: Int) -> some View {
//        Button(action: { selectedZoom = zoom }) {
//            Text("\(zoom)x")
//                .font(.system(size: 12, weight: .medium))
//                .foregroundColor(.white)
//                .frame(width: 40, height: 40)
//                .background(Color.black.opacity(selectedZoom == zoom ? 0.7 : 0.5))
//                .clipShape(Circle())
//        }
//    }
//}
//
//// MARK: - Bottom Menu
//struct BottomMenu: View {
//    @Binding var saveToDevice: Bool
//    let isLandscape: Bool
//    let isLandscapeLeft: Bool
//    let isPortraitUpsideDown: Bool
//    let geometry: GeometryProxy
//    
//    var body: some View {
//        if isLandscape {
//            landscapeMenu
//        } else {
//            portraitMenu
//        }
//    }
//    
//    // MARK: - Landscape Menu
//    private var landscapeMenu: some View {
//        VStack(spacing: 32) {
//            // Upload Media
//            VStack(spacing: 8) {
//                Image(systemName: "square.and.arrow.up")
//                    .font(.system(size: 22))
//                    .foregroundColor(.white)
//                
//                Text("Upload Media")
//                    .font(.system(size: 11, weight: .medium))
//                    .foregroundColor(.white)
//                    .fixedSize()
//            }
//            .rotationEffect(.degrees(isLandscapeLeft ? 90 : -90))
//            
//            // Save to Device Toggle
//            VStack(spacing: 8) {
//                Toggle("", isOn: $saveToDevice)
//                    .labelsHidden()
//                    .scaleEffect(0.8)
//                    .toggleStyle(SwitchToggleStyle(tint: .purple))
//                
//                Text("Save to Device")
//                    .font(.system(size: 11, weight: .medium))
//                    .foregroundColor(saveToDevice ? .white : .gray)
//                    .fixedSize()
//            }
//            .rotationEffect(.degrees(isLandscapeLeft ? 90 : -90))
//            
//            // Live Button
//            Button(action: {}) {
//                Image("ic-live")
//                    .resizable()
//                    .frame(width: 56, height: 56)
//            }
//            .rotationEffect(.degrees(isLandscapeLeft ? 90 : -90))
//        }
//        .position(
//            x: isLandscapeLeft ? 48 : geometry.size.width - 48,
//            y: geometry.size.height / 2
//        )
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLandscapeLeft)
//    }
//    
//    // MARK: - Portrait Menu
//    private var portraitMenu: some View {
//        HStack(spacing: 0) {
//            VStack(spacing: 8) {
//                Text("Upload Media")
//                    .font(.system(size: 11, weight: .medium))
//                    .foregroundColor(.white)
//                Image(systemName: "square.and.arrow.up")
//                    .font(.system(size: 22))
//                    .foregroundColor(.white)
//            }
//            .frame(width: 95, height: 46)
//            
//            VStack(spacing: 8) {
//                Text("Save to Device")
//                    .font(.system(size: 11, weight: .medium))
//                    .foregroundColor(saveToDevice ? .white : .gray)
//                Toggle("", isOn: $saveToDevice)
//                    .labelsHidden()
//                    .scaleEffect(0.8)
//                    .toggleStyle(SwitchToggleStyle(tint: .purple))
//            }
//            .frame(maxWidth: .infinity)
//            
//            Button(action: {}) {
//                Image("ic-live")
//                    .resizable()
//                    .frame(width: 46, height: 46)
//            }
//            .frame(width: 95, height: 46)
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 16)
//        .frame(width: geometry.size.width, height: 96)
//        .background(Color.black)
//        .rotationEffect(.degrees(isPortraitUpsideDown ? 180 : 0))
//        .position(
//            x: geometry.size.width / 2,
//            y: isPortraitUpsideDown ? 48 : geometry.size.height - 48
//        )
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPortraitUpsideDown)
//    }
//}
//
//// MARK: - Preview
//struct RecordingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            RecordingScreen()
//                .previewInterfaceOrientation(.portrait)
//                .previewDisplayName("Portrait")
//            
//            RecordingScreen()
//                .previewInterfaceOrientation(.portraitUpsideDown)
//                .previewDisplayName("Portrait Upside Down")
//            
//            RecordingScreen()
//                .previewInterfaceOrientation(.landscapeRight)
//                .previewDisplayName("Landscape Right")
//            
//            RecordingScreen()
//                .previewInterfaceOrientation(.landscapeLeft)
//                .previewDisplayName("Landscape Left")
//        }
//    }
//}
