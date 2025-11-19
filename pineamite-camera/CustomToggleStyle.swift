//
//  CustomToggleStyle.swift
//  pineamite-camera
//
//  Created by Ibraiz Qazi on 11/19/25.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    var onColor: Color = .white
    var offColor: Color = .gray
    var thumbColor: Color = Color(red: 44, green: 0, blue: 133)
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 51, height: 31)
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
