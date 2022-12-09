//
//  GameScene.swift
//  LandOfFires Shared
//
//  Created by antonia on 06/12/22.
//

import SpriteKit

class GameScene: SKScene {
    
    var fairy = SKSpriteNode()
    var fairyMoveUp = SKAction()
    var fairyMoveDown = SKAction()
    
    let backgroundVelocity: CGFloat = 3.0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        self.addBackground()
        self.addFairy()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    
    func addFairy() {
        fairy = SKSpriteNode(imageNamed: "fairy")
        fairy.setScale(0.25)
        
        fairy.physicsBody = SKPhysicsBody(rectangleOf: fairy.size)
        fairy.physicsBody?.isDynamic = true
        fairy.name = "fairy"
        fairy.position = CGPoint(x: 100, y: 100)
        
        
        fairyMoveUp = SKAction.moveBy(x: 0, y: 30, duration: 0.2)
        fairyMoveDown = SKAction.moveBy(x: 0, y: -30, duration: 0.2)
        
        self.addChild(fairy)
        
    }

    func addBackground() {
        for index in 0..<2{
            let bg = SKSpriteNode(imageNamed: "background")
            bg.position = CGPoint (x: index * Int(bg.size.width), y: 0)
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.name = "background"
            
            self.addChild(bg)
            
        }
    }
    func moveBackground() {
        self.enumerateChildNodes(withName: "background", using: {(node, stop)-> Void in
            if let bg = node as? SKSpriteNode {
                bg.position = CGPoint(x: bg.position.x - self.backgroundVelocity, y: bg.position.y)
                
                if bg.position.x <= -bg.size.width{
                    bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                }
            }
        })
    }
    override func update(_ currentTime: TimeInterval) {
        self.moveBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if location.y > fairy.position.y{
                if fairy.position.y < 300 {
                    fairy.run(fairyMoveUp)
                }
            } else {
                 if fairy.position.y > 50 {
                    fairy.run(fairyMoveDown)
                }
            }
                
        }
    }
    
}


