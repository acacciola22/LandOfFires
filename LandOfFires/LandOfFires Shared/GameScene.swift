//
//  GameScene.swift
//  LandOfFires Shared
//
//  Created by antonia on 06/12/22.
//

import CoreMotion
import SpriteKit

enum CollisionType: UInt32 {
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameViewControllerBridge: GameViewController!
    let motionManager = CMMotionManager()
    
//    let player = SKSpriteNode(imageNamed: "player")
    var player = SKSpriteNode()
    var playerMoveUp = SKAction()
    var playerMoveDown = SKAction()
    
    
    var lastEnemyAdded: TimeInterval = 0
    
    let backgroundVelocity: CGFloat = 3.0
    let enemyVelocity: CGFloat = 5.0
    
    
    let playerCategory = 0x1 << 0
    let enemyCategory = 0x1 << 1
    let componentCategory = 0x1 << 0
    let shootCategory = 0x1 << 0
    
    
    let waves = Bundle.main.decode([Wave].self, from: "waves.geojson")
    let enemyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types.geojson")

    var isPlayerAlive = true
    var levelNumber = 0
    var waveNumber = 0
    var playerShields = 10

    let positions = Array(stride(from: -320, through: 320, by: 80))

    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        if let particles = SKEmitterNode(fileNamed: "Starfield") {
            particles.position = CGPoint(x: 1080, y: 0)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            addChild(particles)
        }

//        player.name = "player"
//        player.position.x = frame.minX + 75
//        player.zPosition = 1
//        addChild(player)
//
//        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
//        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
//        player.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
//        player.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
//        player.physicsBody?.isDynamic = false
//
//        motionManager.startAccelerometerUpdates()
        
        addBackground()
        addPlayer()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
    }



//        func touchDown(atPoint pos: CGPoint) {
//            jump()
//        }
//
//        func jump() {
//            player.texture = SKTexture(imageNamed: "player")
//            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
//        }

//        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//            for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//        }
//
//        func touchUp(atPoint pos: CGPoint) {
//            player.texture = SKTexture(imageNamed: "player")
//        }

    override func update(_ currentTime: TimeInterval) {
        
        
        self.moveBackground()
        
        
        if let accelerometerData = motionManager.accelerometerData {
            player.position.y += CGFloat(accelerometerData.acceleration.x * 50)

            if player.position.y < frame.minY {
                player.position.y = frame.minY
            } else if player.position.y > frame.maxY {
                player.position.y = frame.maxY
            }
        }

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
            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = secondNode.position
                addChild(explosion)
            }

            firstNode.removeFromParent()
            secondNode.removeFromParent()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       guard isPlayerAlive else { return }

     //   for t in touches { self.touchDown(atPoint: t.location(in: self))}
        
        
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

//        let shot = SKSpriteNode(imageNamed: "playerWeapon")
//        shot.name = "playerWeapon"
//        shot.position = player.position
//
//        shot.physicsBody = SKPhysicsBody(rectangleOf: shot.size)
//        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon.rawValue
//        shot.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
//        shot.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
//        addChild(shot)
//
//        let movement = SKAction.move(to: CGPoint(x: 1900, y: shot.position.y), duration: 5)
//        let sequence = SKAction.sequence([movement, .removeFromParent()])
//        shot.run(sequence)


    }
    
    func shoot() {
        
        let projectile = SKSpriteNode(imageNamed: "playerWeapon")
        projectile.zPosition = 1
        projectile.position = CGPoint(x: player.position.x, y: player.position.y)

        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = UInt32(shootCategory)
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

//        let gameOver = SKSpriteNode(imageNamed: "gameOver")
//        addChild(gameOver)
        
        let gameOverScene = GameOverScene(size: self.size)
        self.view?.presentScene(gameOverScene, transition: .doorway(withDuration: 1))
    }


//    func reloadGame(){
//
//        coinObject.removeAllChildren()
//        redCoinObject.removeAllChildren()
//        movingObject.removeAllChildren()
//        heroObject.removeAllChildren()
//
//        levelLabel.text = "Level 1"
//        gameOver = 0
//
//        scene?.isPaused = false
//
//        coinObject.speed = 1
//        redCoinObject.speed = 1
//        heroObject.speed = 1
//        movingObject.speed = 1
//        self.speed = 1
//
//        if labelObject.children.count != 0{
//            labelObject.removeAllChildren()
//        }
//
//        createBackground()
//        createLowerBorderForNodes()
//        createUpperBorderForNodes()
//        createHero()
//        createEngineFlames()
//
//        score = 0
//        scoreLabel.text = "0"
//        levelLabel.isHidden = false
//        highScoreTextLabel.isHidden = true
//
//        showHighScore()
//
//        timerForAddingCoin.invalidate()
//        timerForAddingRedCoin.invalidate()
//        timerForElectricGate.invalidate()
//        timerForMine.invalidate()
//        timerForShieldItem.invalidate()
//
//        timerFunc()
//
//    }

    
    func addPlayer () {
        
        player = SKSpriteNode(imageNamed: "player")
        player.setScale(0.40)
//        player.zRotation = CGFloat(-3/2)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        
        
        // collision
        player.physicsBody?.categoryBitMask = UInt32(playerCategory)
        player.physicsBody?.contactTestBitMask = UInt32(enemyCategory)
        player.physicsBody?.collisionBitMask = 0
        
        
        player.name = "player"
        player.position = CGPoint(x: 120, y: 160)
        
        
        playerMoveUp = SKAction.moveBy(x: 0, y: 30, duration: 0.2)
        playerMoveDown = SKAction.moveBy(x: 0, y: -30, duration: 0.2)
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
    
    
}


