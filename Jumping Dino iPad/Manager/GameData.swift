//
//  GameData.swift
//  Jumping Dino iPad
//
//  Created by Ethan Chew on 14/1/23.
//

import Foundation

class GameData: ObservableObject {
    @Published var pointData: PointData = PointData(calibratedPoint: CGPoint(), currentPoint: CGPoint())
    @Published var jumpYTarget: CGFloat = 0.0
    @Published var updateCalibratedPoint: Bool = false
    @Published var isJump: Bool = false
    @Published var currentScore: Int = 0
}

struct PointData {
    var calibratedPoint: CGPoint
    var currentPoint: CGPoint
}
