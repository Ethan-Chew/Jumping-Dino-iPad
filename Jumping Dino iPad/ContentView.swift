//
//  ContentView.swift
//  Jumping Dino iPad
//
//  Created by Ethan Chew on 10/1/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View, JumpingDinoDelegate {
    
    @State var isGame: Bool = false
    @State var isJump: Bool = false
    @State var score = 0
    @ObservedObject var gameData = GameData()
    
    var gameScene: SKScene {
        let scene = JumpingDinoScene()
        scene.size = CGSize(width: UIScreen.main.bounds.size.width, height: ((UIScreen.main.bounds.size.height/3)/3)*1.5)
        scene.scaleMode = .fill
        scene.jumpingDinoDelegate = self
        scene.view?.showsPhysics = true
        return scene
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottom) {
                ZStack {
                    CameraView(gameData: gameData)
                        .ignoresSafeArea()
                    VStack {
                        HStack {
                            Spacer()
                            
                            if gameData.pointData.calibratedPoint.x != 0 && gameData.pointData.calibratedPoint.y != 0 {
                                Text("**Score:** \(score)")
                                    .padding()
                                    .background(.black.opacity(0.6))
                                    .cornerRadius(9)
                            }
                            
                            Spacer()
                        }
                        .offset(y: 10)
                        Spacer()
                    }
                }
                
                VStack {
                    VStack {
                        VStack {
                            
                            Text("Jumping Dino on iPad")
                                .bold()
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding()
                            
                            HStack {
                                Button {
                                    gameData.updateCalibratedPoint = true
                                    self.isGame = true
                                } label: {
                                    Text("Calibrate Position")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(.systemBlue))
                                        .cornerRadius(10)

                                }
                                Button {

                                } label: {
                                    Text("Reset Game")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(.systemRed))
                                        .cornerRadius(10)

                                }

                            }
                        }
                        .padding()
                        
                        SpriteView(scene: self.gameScene)
                            .frame(width: reader.size.width, height: ((reader.size.height/3)/3)*2)
                            .ignoresSafeArea()
                    }
                }
                .frame(height: reader.size.height/3)
                .background(.white)
                .ignoresSafeArea()
                
                VStack {
                    if gameData.pointData.calibratedPoint.x == 0 && gameData.pointData.calibratedPoint.y == 0 {
                        Text("Not Calibrated!")
                            .font(.largeTitle)
                            .bold()
                            .padding(20)
                            .background(.red.opacity(0.8))
                            .cornerRadius(9)
                    }
                    if isJump {
                        Text("Boing!")
                            .font(.largeTitle)
                            .bold()
                            .padding(20)
                            .background(.blue.opacity(0.9))
                            .cornerRadius(9)
                    }
                    Spacer()
                }
                .padding(.top, 50)
                
            }.ignoresSafeArea()
                .onChange(of: gameData.isJump) { _ in
                    Task {
                        if gameData.isJump {
                            isJump = true
                            try await Task.sleep(for: .seconds(0.5))
                            gameData.isJump = false
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isGame: false)
    }
}
