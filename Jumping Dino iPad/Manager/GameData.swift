//
//  GameData.swift
//  Jumping Dino iPad
//
//  Created by Ethan Chew on 14/1/23.
//

import Foundation

class GameData: ObservableObject {
    @Published var pointData: PointData = PointData(calibratedPoint: CGPoint(), currentPoint: CGPoint())
    @Published var updateCalibratedPoint: Bool = false
}

struct PointData {
    var calibratedPoint: CGPoint
    var currentPoint: CGPoint
}
