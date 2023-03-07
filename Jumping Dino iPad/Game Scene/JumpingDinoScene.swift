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

protocol JumpingDinoDelegate {
    var isGame: Bool { get set }
    var isJump: Bool { get set }
    var resetGame: Bool { get set }
}

private struct CollisionBitMask {
    static let dino: UInt32 = 0x1 << 2
    static let cactus: UInt32 = 0x1 << 3
    static let ground: UInt32 = 0x1 << 1
}

class JumpingDinoScene: SKScene, SKPhysicsContactDelegate {
    
    var jumpingDinoDelegate: JumpingDinoDelegate? = nil
    
    // Game Info
    let cactusGroup = [1, 2, 3]
    var backgroundSpeed: CGFloat = 100
    var lastUpdateTimeInterval: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var groundHeight: CGFloat = 0
    var lastTime = 0
    var showCactusTimer = 0.0
    var lastCactusTime = 0
    var numOfCactusShown = 0
    var removedCactusNum = 0
    var showCactusMinMax: [Double] = [3, 6.5]
    
    private func setupGround() {
        for i in 0..<3 {
            let ground = SKSpriteNode(imageNamed: "DinosaurGameGround")
            ground.zPosition = -1
            ground.size.width = frame.width
            ground.position = CGPoint(x: CGFloat(i) * size.width - 2, y: ground.size.height/3)
            ground.name = "Ground"
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size)
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.allowsRotation = false
            ground.physicsBody?.friction = 0
            ground.physicsBody?.restitution = 0
            ground.physicsBody?.categoryBitMask = CollisionBitMask.ground
            self.addChild(ground)
            groundHeight = ground.size.height
            
        }
    }
    
    private func setupCactus() {
        numOfCactusShown += 1
        
        let cactusImgs = ["cactus1", "cactus2", "cactus3", "doubleCactus", "tripleCactus"]
        let scale: CGFloat = 1.7
        
        let cactusTexture = SKTexture(image: UIImage.init(named: cactusImgs.randomElement()!)!)
        cactusTexture.filteringMode = .nearest
        
        let cactusSprite = SKSpriteNode(texture: cactusTexture)
        cactusSprite.setScale(scale)
        cactusSprite.name = "Cactus \(numOfCactusShown)"
        cactusSprite.zPosition = 1
        cactusSprite.position = CGPoint(x: (scene?.size.width)!+30, y: (groundHeight/2)*scale)
        cactusSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cactusTexture.size().width, height: cactusTexture.size().height))
        cactusSprite.physicsBody?.isDynamic = false
        cactusSprite.physicsBody?.mass = 1.0
        cactusSprite.physicsBody?.restitution = 0
        cactusSprite.physicsBody?.allowsRotation = false
        cactusSprite.physicsBody?.friction = 0
        cactusSprite.physicsBody?.categoryBitMask = CollisionBitMask.cactus
        cactusSprite.physicsBody?.contactTestBitMask = CollisionBitMask.dino
        cactusSprite.physicsBody?.collisionBitMask = CollisionBitMask.dino
        
        cactus.addChild(cactusSprite)
        showCactusTimer = Double.random(in: showCactusMinMax[0]...showCactusMinMax[1])

    }
    
    private func updateGroundMovement() {
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
        cactus.enumerateChildNodes(withName: "Cactus \(cactusNum)") { (node, stop) in
            if let back = node as? SKSpriteNode {
                let move = CGPoint(x: -self.backgroundSpeed * CGFloat(self.deltaTime), y: 0)
                back.position += move
                
                if back.position.x < -30 {
                    self.removeCactus(cactusNum: cactusNum)
                }
            }
        }
    }
    
    private func removeCactus(cactusNum: Int) {
        cactus.enumerateChildNodes(withName: "Cactus \(cactusNum)") { (node, stop) in
            if let back = node as? SKSpriteNode {
                back.removeFromParent()
                let num = back.name?.components(separatedBy: " ")
                self.removedCactusNum = Int(num![1])!
            }
        }
    }
    
    // Nodes
    let dino = SKLabelNode(text: "🦖")
    let cactus = SKNode()
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = .white
        physicsWorld.contactDelegate = self
        
        setupGround()
        
        dino.fontSize = 75
        dino.position = CGPoint(x: dino.fontSize/2+10, y: groundHeight/2)
        dino.zPosition = 1
        dino.xScale = -1.0
        
        // Dino Physics
        dino.physicsBody = SKPhysicsBody(rectangleOf: dino.frame.size)
        dino.physicsBody?.mass = 0.5
        dino.physicsBody?.isDynamic = true
        dino.physicsBody?.allowsRotation = false
        dino.physicsBody?.friction = 0
        dino.physicsBody?.restitution = 0.1
        dino.physicsBody?.categoryBitMask = CollisionBitMask.dino
        dino.physicsBody?.contactTestBitMask = CollisionBitMask.cactus
        dino.physicsBody?.collisionBitMask = CollisionBitMask.cactus
        self.addChild(dino)
        
        // Game Physics
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: groundHeight/2, right: -100)))
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        
        // Cactus
        cactus.zPosition = 1
        self.addChild(cactus)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let gotReset = jumpingDinoDelegate?.resetGame else { return }
        if gotReset {
            cactus.removeAllChildren()
            
            self.backgroundSpeed = 85
            self.lastUpdateTimeInterval = 0
            self.deltaTime = 0
            self.lastTime = 0
            self.showCactusTimer = 0.0
            self.lastCactusTime = 0
            self.numOfCactusShown = 0
            self.removedCactusNum = 0
            self.showCactusMinMax = [3, 6.5]
            
            self.jumpingDinoDelegate?.resetGame = false
            self.jumpingDinoDelegate?.isGame = true
        }
        
        guard let gotGame = jumpingDinoDelegate?.isGame else { return }
        if gotGame {
            if lastUpdateTimeInterval == 0 {
                lastUpdateTimeInterval = currentTime
                lastTime = Int(currentTime)
                lastCactusTime = Int(currentTime)
            }
            
            if lastTime != Int(currentTime) { // Updates every second
                lastTime = Int(currentTime)
                if backgroundSpeed < 400 {
                    backgroundSpeed += 4
                }
                if showCactusMinMax[0] >= 2.0 {
                    showCactusMinMax[0] += 0.1
                }
                if showCactusMinMax[1] >= 4.0 {
                    showCactusMinMax[1] += 0.1
                }
            }
            
            if Int(Double(lastCactusTime) + showCactusTimer) == Int(currentTime) {
                lastCactusTime = Int(currentTime)
                setupCactus()
            }
            
            deltaTime = currentTime - lastUpdateTimeInterval
            lastUpdateTimeInterval = currentTime
            
            guard let gotJump = jumpingDinoDelegate?.isJump else { return }
            if gotJump {
                dino.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
                jumpingDinoDelegate?.isJump = false
            }
                        
            updateGroundMovement()
            if numOfCactusShown - removedCactusNum != 0 {
                for cactusNum in 1...numOfCactusShown - removedCactusNum {
                    updateCactusMovement(cactusNum: cactusNum + removedCactusNum)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CollisionBitMask.dino && contact.bodyB.categoryBitMask == CollisionBitMask.cactus || contact.bodyA.categoryBitMask == CollisionBitMask.cactus && contact.bodyB.categoryBitMask == CollisionBitMask.dino {
            jumpingDinoDelegate?.isGame = false
        }
    }
}
