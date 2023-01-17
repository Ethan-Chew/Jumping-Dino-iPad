//
//  JumpingDinoScene.swift
//  Jumping Dino iPad
//
//  Created by Ethan Chew on 15/1/23.
//

import Foundation
import SpriteKit

fileprivate func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

fileprivate func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

class JumpingDinoScene: SKScene {
    
    var gameData = GameData()
    
    // Game Info
    let cactusGroup = [1, 2, 3]
    var backgroundSpeed: CGFloat = 85
    var lastUpdateTimeInterval: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var groundHeight: CGFloat = 0
    var lastTime = 0
    var showCactusTimer = 0.0
    var lastCactusTime = 0
    var numOfCactusShown = 0
    var removedCactusNum = 0
    var showCactusMinMax: [Double] = [3, 6.5]
    
    func setupGround() {
        for i in 0..<3 {
            let ground = SKSpriteNode(imageNamed: "DinosaurGameGround")
            ground.zPosition = -1
            ground.size.width = frame.width
            ground.position = CGPoint(x: CGFloat(i) * size.width - 2, y: ground.size.height/2)
            ground.name = "Ground"
            self.addChild(ground)
            groundHeight = ground.size.height
            
        }
    }
    
    func setupCactus(_ num: Int) {
        var cactus = ""
        for _ in 0..<num {
            cactus += "🌵"
        }
        
        let cactusGroup = SKLabelNode(text: cactus)
        cactusGroup.position = CGPoint(x: (scene?.size.width)! + 50, y: groundHeight/2)
        cactusGroup.fontSize = 45
        numOfCactusShown += 1
        cactusGroup.zPosition = 1
        cactusGroup.name = "Cactus \(numOfCactusShown)"
        self.addChild(cactusGroup)
        
        showCactusTimer = Double.random(in: showCactusMinMax[0]...showCactusMinMax[1])
    }
    
    func updateGroundMovement() {
        self.enumerateChildNodes(withName: "Ground") { (node, stop) in
            
            if let back = node as? SKSpriteNode {
                let move = CGPoint(x: -self.backgroundSpeed * CGFloat(self.deltaTime), y: 0)
                back.position += move
                
                if back.position.x < -back.size.width {
                    back.position += CGPoint(x: back.size.width * CGFloat(3), y: 0)
                }
            }
            
        }
    }
    
    func updateCactusMovement(cactusNum: Int) {
        print("Cactus \(cactusNum)", "in movement")
        self.enumerateChildNodes(withName: "Cactus \(cactusNum)") { (node, stop) in
            if let back = node as? SKLabelNode {
                let move = CGPoint(x: -self.backgroundSpeed * CGFloat(self.deltaTime), y: 0)
                back.position += move
                
                if back.position.x < -30 {
                    back.removeFromParent()
                    let num = back.name?.components(separatedBy: " ")
                    self.removedCactusNum = Int(num![1])!
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = .white
        
        setupGround()
        
        let dino = SKLabelNode(text: "🦖")
        dino.fontSize = 90
        dino.position = CGPoint(x: dino.fontSize/2+10, y: groundHeight/2)
        dino.zPosition = 1
        
        // Dino Physics
        dino.physicsBody = SKPhysicsBody(circleOfRadius: dino.fontSize/4)
        dino.physicsBody?.allowsRotation = false
        dino.physicsBody?.friction = 0
        dino.physicsBody?.restitution = 0.1
        addChild(dino)
        
        // Game Physics
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: groundHeight/3, left: 0, bottom: 0, right: 0)))
        
        // Show Cactus
        showCactusTimer = Double.random(in: showCactusMinMax[0]...showCactusMinMax[1])
        setupCactus(cactusGroup[Int.random(in: 0..<3)])
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
            lastTime = Int(currentTime)
            lastCactusTime = Int(currentTime)
        }
        
        if lastTime != Int(currentTime) { // Updates every second
            lastTime = Int(currentTime)
            backgroundSpeed += 4
            if showCactusMinMax[0] >= 2.0 {
                showCactusMinMax[0] -= 0.1
            }
            if showCactusMinMax[1] >= 4.0 {
                showCactusMinMax[1] -= 0.1
            }
        }
        
        if Int(Double(lastCactusTime) + showCactusTimer) == Int(currentTime) {
            lastCactusTime = Int(currentTime)
            setupCactus(cactusGroup[Int.random(in: 0..<3)])
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        updateGroundMovement()
        if numOfCactusShown - removedCactusNum != 0 {
            for cactusNum in 1...numOfCactusShown - removedCactusNum {
                updateCactusMovement(cactusNum: cactusNum + removedCactusNum)
            }
        }
    }
}
