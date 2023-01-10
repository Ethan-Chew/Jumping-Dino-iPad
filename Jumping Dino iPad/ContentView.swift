//
//  ContentView.swift
//  Jumping Dino iPad
//
//  Created by Ethan Chew on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CameraView()
                .ignoresSafeArea()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
