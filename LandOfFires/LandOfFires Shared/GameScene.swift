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
    
    var lastWheelAdded: TimeInterval = 0
    
    let backgroundVelocity: CGFloat = 3.0
    let wheelVelocity: CGFloat = 5.0
    
    let swipeUp = UISwipeGestureRecognizer()
    let swipeDown = UISwipeGestureRecognizer()
    
    // FATINA ANIMATA
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    var MainFairy = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        TextureAtlas = SKTextureAtlas(named: "fairy")
        
//        NSLog("\(TextureAtlas.textureNames)")
        
        for i in 1...TextureAtlas.textureNames.count{
            var Name = "fatina_\(i).png"
            TextureArray.append(SKTexture(imageNamed: Name))
        }
        
        MainFairy = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0] )
        MainFairy.size = CGSize(width: 40, height: 50)
        MainFairy.position = CGPoint(x: 120, y: 100)
        MainFairy.physicsBody?.isDynamic = true
        MainFairy.physicsBody = SKPhysicsBody(rectangleOf: fairy.size)
        
        
        self.backgroundColor = .white
        self.addBackground()
//        self.addFairy()
        self.addWheel()
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
        swipeUp.addTarget(self, action: #selector(self.swipedUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        swipeDown.addTarget(self, action: #selector(self.swipedDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
   @objc func swipedUp() {
       fairy.run(fairyMoveUp)
    }
    
    @objc func swipedDown() {
        fairy.run(fairyMoveDown)
     }
    
    
//    func addFairy() {
//        fairy = SKSpriteNode(imageNamed: "fairy")
//        fairy.setScale(0.25)
//
//        fairy.physicsBody = SKPhysicsBody(rectangleOf: fairy.size)
//        fairy.physicsBody?.isDynamic = true
//        fairy.name = "fairy"
//        fairy.position = CGPoint(x: 100, y: 100)
//
//
//        fairyMoveUp = SKAction.moveBy(x: 0, y: +200, duration: 0.5)
//        fairyMoveDown = SKAction.moveBy(x: 0, y: -200, duration: 0.5)
//
//        self.addChild(fairy)
//
//    }

    func addBackground() {
        for index in 0..<2{
            let bg = SKSpriteNode(imageNamed: "background")
            bg.position = CGPoint (x: index * Int(bg.size.width), y: 0)
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.name = "background"
            
            self.addChild(bg)
            
        }
    }
    
    func addWheel() {
        let wheel = SKSpriteNode(imageNamed: "wheel")
        wheel.setScale(0.15)
        wheel.physicsBody = SKPhysicsBody(rectangleOf: wheel.size)
        wheel.physicsBody?.isDynamic = true
        wheel.name = "wheel"
        
        let random: CGFloat = CGFloat(arc4random_uniform(300))
        wheel.position = CGPoint(x: self.frame.size.width + 20, y: random)
        self.addChild(wheel)
        
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
    
    func moveWheel() {
        self.enumerateChildNodes(withName: "wheel", using: {(node, stop)-> Void in
            if let wheel = node as? SKSpriteNode {
                wheel.position = CGPoint(x: wheel.position.x - self.wheelVelocity, y: wheel.position.y)
                
                if wheel.position.x < 0 {
                    wheel.removeFromParent()
                }
            }
        })
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        self.moveBackground()
        self.moveWheel()
        
        if currentTime - self.lastWheelAdded > 1 {
            self.lastWheelAdded = currentTime + 1
            self.addWheel()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            MainFairy.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.3)))
    }
}


