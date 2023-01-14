//
//  ContentView.swift
//  Jumping Dino iPad
//
//  Created by Ethan Chew on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var score = 0
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                ZStack {
                    CameraView()
                        .ignoresSafeArea()
                        .frame(height: (reader.size.height/3)*2)
                    VStack {
                        HStack {
                            Spacer()
                            Text("**Score:** \(score)")
                                .padding()
                                .background(.black)
                                .opacity(0.6)
                                .cornerRadius(9)
                            Spacer()
                        }
                        .offset(y: 10)
                        Spacer()
                    }
                }
                VStack {
                    VStack {
                        Text("Jumping Dino on iPad")
                            .bold()
                            .font(.largeTitle)
                        HStack {
                            Button {
                                
                            } label: {
                                Text("Calibrate Position")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(.systemBlue))
                                    .cornerRadius(10)
                                    
                            }
                            Button {
                                
                            } label: {
                                Text("Reset Score")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(.systemRed))
                                    .cornerRadius(10)
                                    
                            }

                        }
                    }
                    .padding()
                    DinoCanvasView(width: reader.size.width, height: ((reader.size.height/3)/3)*1.5)
                    Spacer()
                }
                .frame(height: reader.size.height/3)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
