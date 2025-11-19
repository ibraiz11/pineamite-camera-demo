//
//  OrientationManager.swift
//  pineamite-camera
//
//  Created by Ibraiz Qazi on 11/15/25.
//

import Foundation
import UIKit
import SwiftUI

enum ScreenOrientation {
    case portrait
    case portraitUpsideDown
    case landscapeLeft
    case landscapeRight
    
    init(device: UIDeviceOrientation) {
        switch device {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: self = .portrait
        }
    }
    
    var isLandscape: Bool {
        self == .landscapeLeft || self == .landscapeRight
    }
    
    var rotation: Double {
        switch self {
        case .portrait: return 0
        case .portraitUpsideDown: return 180
        case .landscapeLeft: return 90
        case .landscapeRight: return -90
        }
    }
    
    var inverseRotationDegrees: Double { -rotation }
}


class OrientationManager: ObservableObject {
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    init() {
        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) {[weak self] _ in
            guard let self = self else { return }
            let new = UIDevice.current.orientation
            if new.isLandscape || new.isPortrait {
                withAnimation(.spring()) {
                    self.orientation = new
                }
            }
        }
    }
}
