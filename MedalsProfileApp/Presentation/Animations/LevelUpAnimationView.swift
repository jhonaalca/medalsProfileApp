//
//  LevelUpAnimationView.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 17/10/25.
//

import Foundation
import SwiftUI

struct LevelUpAnimationView: View {
    let medal: Medal
    let animationType: AnimationType
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Fondo semitransparente
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            // Contenido principal
            VStack(spacing: 20) {
                medalIcon
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                
                VStack(spacing: 12) {
                    Text("¡Nivel Alcanzado!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(medal.name)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("Ahora eres Nivel \(medal.level)")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(medal.reward)
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .fontWeight(.medium)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue.gradient)
                    .shadow(radius: 20)
            )
            .padding(40)
            .scaleEffect(isAnimating ? 1.0 : 0.5)
            .opacity(isAnimating ? 1.0 : 0.0)
            
            // Animación específica basada en el tipo
            switch animationType {
            case .sparkle:
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .confetti:
                //ConfettiAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .pulse:
                //PulseAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .scalePop:
                //ScalePopAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .flash:
                //FlashAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .rotate:
                //RotateAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .shine:
                //ShineAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .bounce:
                //BounceAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .explosion:
                //ExplosionAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            case .crownBurst:
                //CrownBurstAnimation(medal: medal, isAnimating: $isAnimating)
                SparkleAnimation(medal: medal, isAnimating: $isAnimating)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }
    
    private var medalIcon: some View {
        Image(systemName: medal.rarity.icon)
            .font(.system(size: 60))
            .foregroundColor(Color(hex: medal.rarity.color))
            .symbolEffect(.bounce, options: .repeating, value: isAnimating)
    }
}

// TODO: Por falta de tiempo me quedo pendiente agregar las demas animaciones.
struct SparkleAnimation: View {
    let medal: Medal
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
                .scaleEffect(isAnimating ? 1.5 : 0.5)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
            
            VStack(spacing: 12) {
                Text("¡Nivel Alcanzado!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(medal.name)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("Ahora eres Nivel \(medal.level)")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.gradient)
                .shadow(radius: 20)
        )
        .padding(40)
    }
}
