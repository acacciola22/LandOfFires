//
//  GameOverScene.swift
//  Merdina
//
//  Created by Rita Marrano on 09/12/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let scores = loadScores()
    var score : Int = 0
//    var gameScore : Int = 0
    
    override init(size: CGSize) {
        
        super.init(size: size)
       
        for index in 0..<2 {
            let bg = SKSpriteNode(imageNamed: "background")
            bg.position = CGPoint(x: index * Int(bg.size.width), y: 0)
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.name = "background"
            
            self.addChild(bg)
        }
        
        var height = frame.height - 55
        let width = frame.width/2


        let titleNode : SKLabelNode = SKLabelNode(fontNamed: "STV5730A")
        titleNode.text = "GAME OVER BABY ! !"
        titleNode.fontSize = 40
        titleNode.fontColor = .black
        titleNode.position.y = height
        height -= 40
        titleNode.position.x = width
        addChild(titleNode)

        let personalScoreNode = SKLabelNode(fontNamed: "STV5730A")
            personalScoreNode.text = "Your current score: \(score)"
            personalScoreNode.position.y = height
            personalScoreNode.position.x = width + 20
            personalScoreNode.fontColor = .black
            addChild(personalScoreNode)
        
//        let personalScoreNode = SKLabelNode(fontNamed: "Copperplate-Light")
//            personalScoreNode.text = "your score: \(gameScore)"
//        personalScoreNode.position.y = frame.width/4
//        personalScoreNode.position.x = frame.height/4
//            personalScoreNode.fontColor = .yellow
//            addChild(personalScoreNode)
//
    
    
//        let label = SKLabelNode(fontNamed: "2Credits")
//        label.text = " GAME OVER "
//        label.fontSize = 50
//        label.fontColor = .white
//        label.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
//        self.addChild(label)
        
        

        
        let hometButton = SKSpriteNode(imageNamed: "buttonHome")
        hometButton.setScale(3.5)
        hometButton.position = CGPoint(x: self.size.width/2 , y: 150)
        hometButton.name = " homeButton "
        self.addChild(hometButton)
        
        
        let startButton = SKSpriteNode(imageNamed: "buttonRetry")
        startButton.setScale(3.5)
        startButton.position = CGPoint(x: self.size.width/2 , y: 50)
        startButton.name = " REPLAY "
        self.addChild(startButton)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            
            if node?.name == " REPLAY " {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 1)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            } else if node?.name == " homeButton "{
                    let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 1)
                    let scene = MenuScene(size: self.view!.bounds.size)
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition:  reveal)
                }
            }
        }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init")
    }
}
