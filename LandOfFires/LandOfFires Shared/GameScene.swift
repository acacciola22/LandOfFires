//
//  GameScene.swift
//  LandOfFires Shared
//
//  Created by antonia on 06/12/22.
//

import CoreMotion
import SpriteKit
import GameplayKit

enum CollisionType: UInt32 {
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
    case component = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
//    var gameViewControllerBridge: GameViewController!
    let motionManager = CMMotionManager()
    
    
    var cam = SKCameraNode()
    
//    var joystick = SKSpriteNode()
//    var joystickKnob = SKSpriteNode()
//    var pad = SKSpriteNode()
    
    var joystick = SKNode(fileNamed: "joystick")
   var joystickKnob = SKNode(fileNamed: "joystickKnob")
    var pad = SKNode(fileNamed: "pad")
    
    let playerSpeed = 7.0
    var joystickAction = false
    
    //MEASURE
    var knobRadius : CGFloat = 25.0
    //SPRITE ENGINE
    var previousTimeInterval : TimeInterval = 0
    var playerIsFacingRight = true
//    let playerSpeed = 7.0
    
    //PLAYER STATE
    var playerStateMachine : GKStateMachine!
    
    
    
    
    var player = SKSpriteNode()
    var playerMoveUp = SKAction()
    var playerMoveDown = SKAction()
    
    
    var lastEnemyAdded: TimeInterval = 0
    
    let backgroundVelocity: CGFloat = 3.0
    let enemyVelocity: CGFloat = 5.0
    
    
    let playerCategory = 0x1 << 0
    let enemyCategory = 0x1 << 1
    let componentCategory = 0x1 << 2
//    let shootCategory = 0x1 << 3
    
    
    let waves = Bundle.main.decode([Wave].self, from: "waves.geojson")
    let enemyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types.geojson")

    var isPlayerAlive = true
    var levelNumber = 0
    var waveNumber = 0
    
    
    
    var playerShields = 10 //VITE
    {
        didSet
        {
            playerShieldsNode.text = "LifeS: \(playerShields)"
            
        }
    }
    
    let playerShieldsNode : SKLabelNode = SKLabelNode(fontNamed: "Cooperplate-Bold")
    
    
    
    
    
    
    var score: Int = -0
    {
        didSet
        {
            scoreNode.text = "Current score: \(score)"
        }
    }
    
    let scoreNode : SKLabelNode = SKLabelNode(fontNamed: "Cooperplate-Bold")
    

    let positions = Array(stride(from: -320, through: 320, by: 80))

    
    
    //MARK: DIDMOVE
    
    
    override func didMove(to view: SKView) {
//        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        
        
        
        //add score label
        scoreNode.zPosition = 2
        scoreNode.position.x = 120
        scoreNode.position.y = 300
        scoreNode.fontSize = 20
        scoreNode.fontColor = .black
        addChild(scoreNode)
        score = 0
        
     
        playerShieldsNode.zPosition = 2
        playerShieldsNode.position.x = 250
        playerShieldsNode.position.y = 300
        playerShieldsNode.fontSize = 20
        playerShieldsNode.fontColor = .red
        addChild(playerShieldsNode)
        playerShields = 10

        enumerateChildNodes(withName: "c3", using: { [self]node, stop in
            
            //        COMPONENT PHYSICS
            let  componentNode = node as! SKSpriteNode
            componentNode.physicsBody = SKPhysicsBody (texture : componentNode.texture!, size: componentNode.size)
            componentNode.physicsBody?.categoryBitMask = UInt32(self.playerCategory)
            componentNode.physicsBody?.collisionBitMask = UInt32(self.componentCategory)
            componentNode.physicsBody?.contactTestBitMask = UInt32(playerCategory)
            componentNode.physicsBody?.affectedByGravity = false
            
        })
        
        if let particles = SKEmitterNode(fileNamed: "Starfield") {
            particles.position = CGPoint(x: 1080, y: 0)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            addChild(particles)
        }

        
        addBackground()
        addPlayer()
        addComponent()
        
        
        
        
        scene!.run(SKAction.sequence([.wait(forDuration: 0.02) ,  .run {
            let backgroundSound = SKAudioNode(fileNamed: "NectarPiano-Song")
            self.addChild(backgroundSound)
        } ]))

//        joystick = SKSpriteNode(imageNamed: "joystick")
//        addChild(joystick)
//        joystickKnob = SKSpriteNode(imageNamed: "knob")
//        addChild(joystickKnob)
//        pad = SKSpriteNode(imageNamed: "pad")
//        addChild(pad)
//
        
//        cam = self.childNode(withName: "camera")! as! SKCameraNode
//        self.camera = cam
//
//        joystick = cam
//            .childNode(withName: "joystick") as! SKSpriteNode
//        joystickKnob = cam
//            .childNode(withName: "knob") as! SKSpriteNode
//        pad = cam
//            .childNode(withName: "pad") as! SKSpriteNode
        
        //: - PLAYER
        player = self
            .childNode(withName: "player") as! SKSpriteNode
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "joy")
        pad = childNode(withName: "pad")
        playerStateMachine = GKStateMachine(states: [JumpingState(playerNode: player)])
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
    }



    override func update(_ currentTime: TimeInterval) {


        self.moveBackground()
        self.moveComponents()

//        if let accelerometerData = motionManager.accelerometerData {
//            player.position.y += CGFloat(accelerometerData.acceleration.x * 100)
//
//            if player.position.y < frame.minY {
//                player.position.y = frame.minY
//            } else if player.position.y > frame.maxY {
//                player.position.y = frame.maxY
//            }
//        }

        for child in children {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }

        let activeEnemies = children.compactMap { $0 as? EnemyNode }

        if activeEnemies.isEmpty {
            createWave()
            addComponent()
        }

        for enemy in activeEnemies {
            guard frame.intersects(enemy.frame) else { continue }

            if enemy.lastFireTime + 1 < currentTime {
                enemy.lastFireTime = currentTime

                if Int.random(in: 0...6) == 0 {
                    enemy.fire()
                }
            }
        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        
        //DISTANCE
        for touch in touches {
            let position = touch.location(in: joystick)
            
            let lenght = sqrt(pow(position.x,2) + pow(position.y,2))
            let angle = atan2(position.y, position.x)
            
            if knobRadius > lenght {
                joystickKnob.position = position
            } else {
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
            
            
        }
    }


    func createWave() {
        guard isPlayerAlive else {
            return
        }

        if waveNumber == waves.count{
            levelNumber += 1
            waveNumber = 0
        }

        let currentWave = waves[waveNumber]
        waveNumber += 1

        let maximumEnemyType = min(enemyTypes.count, levelNumber + 1)
        let enemyType = Int.random(in: 0..<maximumEnemyType)

        let enemyOffesetX: CGFloat = 100
        let enemyStartX = 600

        if currentWave.enemies.isEmpty {
            for (index, position) in positions.shuffled().enumerated(){
                let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: position), xOffset: enemyOffesetX * CGFloat(index * 3), moveStraight: true)
                addChild(enemy)
            }} else {
                for enemy in currentWave.enemies {
                    let node = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: positions[enemy.position]), xOffset: enemyOffesetX * enemy.xOffset, moveStraight: enemy.moveStraight)
                    addChild(node)
                }
            }

        }


    
    func addComponent() {
        let component = SKSpriteNode(imageNamed: "c3")
        component.setScale(0.45)
        component.physicsBody = SKPhysicsBody(rectangleOf: component.size)
        component.physicsBody?.isDynamic = true
        component.name = "component"
        
        component.physicsBody?.categoryBitMask = UInt32(componentCategory)
        component.physicsBody?.contactTestBitMask = UInt32(playerCategory)
        component.physicsBody?.collisionBitMask = 1
        component.physicsBody?.usesPreciseCollisionDetection = true
        
        let random: CGFloat = CGFloat(arc4random_uniform(100))
        component.position = CGPoint(x: self.frame.size.width + 20, y: random)
        self.addChild(component)
    }
    
    func moveComponents() {
        self.enumerateChildNodes(withName: "component", using: { (node, stop) -> Void in
            if let component = node as? SKSpriteNode {
                component.position = CGPoint(x: component.position.x - self.enemyVelocity, y: component.position.y)
                
                if component.position.x < 0  {
                    component.removeFromParent()
                }
            }

            
        })
    }
    


    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]

        if secondNode.name == "player" {
            guard isPlayerAlive else { return }

            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = firstNode.position
                addChild(explosion)
            }

            playerShields -= 1

            if playerShields == 0 {
                gameOver()
                updateHighScore(with: score)
//                let gameOverScene = GameOverScene(size: self.size)
//                self.view?.presentScene(gameOverScene, transition: .doorway(withDuration: 1))
//                secondNode.removeFromParent()
            }

            firstNode.removeFromParent()
        } else if let enemy = firstNode as? EnemyNode {
            enemy.shields -= 1

            if enemy.shields == 0 {
                if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                    explosion.position = enemy.position
                    addChild(explosion)
                }
                enemy.removeFromParent()
            }

            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = enemy.position
                addChild(explosion)

            }
            
            secondNode.removeFromParent()
        } else {
            if let explosion = SKEmitterNode(fileNamed: "MyParticle") {
                explosion.position = secondNode.position
                addChild(explosion)
                score += 1
            }
            firstNode.removeFromParent()
            secondNode.removeFromParent()
        }
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if (nodeA.name == "component" && nodeB == player) || (nodeA == player && nodeB.name == "component") {
            
            if contact.bodyB.node?.name == "component"{
                score += 10
                contact.bodyB.node?.removeFromParent()
            }
            
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       guard isPlayerAlive else { return }

     //   for t in touches { self.touchDown(atPoint: t.location(in: self))}
//        for touch in touches {
//            if let joystickKnob = joystickKnob {
//                let location = touch.location(in: joystick!)
//                joystickAction = joystickKnob.frame.contains(location)
//            }
//
//            let location = touch.location(in: self)
//            if !(joystick?.contains(location))! {
//                playerStateMachine.enter(JumpingState.self)
//            }
//        }
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if location.y > player.position.y {
                if player.position.y < 500 {
                    player.run(playerMoveUp)
                    shoot()

                }
            } else {
                if player.position.y > 50 {
                    player.run(playerMoveDown)
                    shoot()

                }
            }
        }

    }
    

    
    func shoot() {
        
        let projectile = SKSpriteNode(imageNamed: "playerWeapon")
        projectile.setScale(0.25)
        projectile.zPosition = 1
        projectile.position = CGPoint(x: player.position.x, y: player.position.y)
        
        

        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = UInt32(playerCategory)
        projectile.physicsBody?.contactTestBitMask = UInt32(enemyCategory)
        projectile.physicsBody?.collisionBitMask = 1
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(projectile)
        let action = SKAction.moveTo(x: self.frame.width + projectile.size.width, duration: 0.5)

        projectile.run(action, completion: {
            projectile.removeAllActions()
            projectile.removeFromParent()
        })
    }

    func gameOver() {
        isPlayerAlive = false

        if let explosion = SKEmitterNode(fileNamed: "Explosion") {
            explosion.position = player.position
            addChild(explosion)
        }

        
        let scoreScene = ScoreScene(size: self.size)
        scoreScene.score = score
        updateHighScore(with: score)
        self.view?.presentScene(scoreScene, transition: .doorway(withDuration: 0.5))
    }


    
    func addPlayer () {
//        physicsWorld.gravity = .zero
        player = SKSpriteNode(imageNamed: "player")
        player.setScale(0.40)
        player.zRotation = CGFloat(-3/2)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.affectedByGravity = false
        
        // collision
        player.physicsBody?.categoryBitMask = UInt32(playerCategory)
        player.physicsBody?.contactTestBitMask = UInt32(enemyCategory)
        player.physicsBody?.collisionBitMask = 1
        
        
        player.name = "player"
        player.position = CGPoint(x: 120, y: 160)
        
        
        playerMoveUp = SKAction.moveBy(x: 0, y: 70, duration: 0.1)
        playerMoveDown = SKAction.moveBy(x: 0, y: -70, duration: 0.1)
        self.addChild(player)
    }
    
    
    
    func addBackground(){

        
        for index in 0..<2 {
            let bg = SKSpriteNode(imageNamed: "background")
            bg.position = CGPoint(x: index * Int(bg.size.width), y: 0)
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.name = "background"
            
            self.addChild(bg)
        }
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "background", using: {(node, stop) -> Void in
            if let bg = node as? SKSpriteNode {
                bg.position = CGPoint(x: bg.position.x - self.backgroundVelocity, y: bg.position.y)
                
                if bg.position.x <= -bg.size.width {
                    bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                }
            }
        })
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let xJoystickCoordinate = touch.location(in: joystick!).x
//            let xLimit: CGFloat = 200.0
//            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
//                resetKnobPosition()
//            }
//
//        }
//    }
    
}


//ACTION

//extension GameScene{
//    func resetKnobPosition () {
//        let initialPoint = CGPoint(x: 0, y: 0)
//        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
//        moveBack.timingMode = .linear
//        joystickKnob?.run(moveBack)
//        joystickAction = false
//    }
//}
//
//
//// GAMELOOP
//
//extension GameScene{
//
//    override func update(_ currentTime: TimeInterval) {
//
//
//
//
//            self.moveBackground()
//            self.moveComponents()
//
//            if let accelerometerData = motionManager.accelerometerData {
//                player.position.y += CGFloat(accelerometerData.acceleration.x * 100)
//
//                if player.position.y < frame.minY {
//                    player.position.y = frame.minY
//                } else if player.position.y > frame.maxY {
//                    player.position.y = frame.maxY
//                }
//            }
//
//            for child in children {
//                if child.frame.maxX < 0 {
//                    if !frame.intersects(child.frame) {
//                        child.removeFromParent()
//                    }
//                }
//            }
//
//            let activeEnemies = children.compactMap { $0 as? EnemyNode }
//
//            if activeEnemies.isEmpty {
//                createWave()
//                addComponent()
//            }
//
//            for enemy in activeEnemies {
//                guard frame.intersects(enemy.frame) else { continue }
//
//                if enemy.lastFireTime + 1 < currentTime {
//                    enemy.lastFireTime = currentTime
//
//                    if Int.random(in: 0...6) == 0 {
//                        enemy.fire()
//                    }
//                }
//            }
//
//        let deltaTime = currentTime - previousTimeInterval
//        previousTimeInterval = currentTime
//
//        // PLAYER MOV
//        guard let joystickKnob = joystickKnob else {return}
//        let xPosition = Double(joystickKnob.position.x)
//        let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
//        let move = SKAction.move(by: displacement, duration: 0)
//
//
//        player.run(move)
//    }
//}
