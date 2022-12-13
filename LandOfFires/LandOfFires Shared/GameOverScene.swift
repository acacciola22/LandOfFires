//
//  GameOverScene.swift
//  LandOfFires iOS
//
//  Created by antonia on 12/12/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    
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
        
        
        
//        let personalScoreNode = SKLabelNode(fontNamed: "Copperplate-Light")
//            personalScoreNode.text = "your score: \(gameScore)"
//        personalScoreNode.position.y = frame.width/4
//        personalScoreNode.position.x = frame.height/4
//            personalScoreNode.fontColor = .yellow
//            addChild(personalScoreNode)
//
    
    
        let label = SKLabelNode(fontNamed: "Cochin")
        label.text = " ViVoglioBene "
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        self.addChild(label)
        
        
        let hometButton = SKSpriteNode(imageNamed: "buttonHome")

//        startButton.text = " START "
//        startButton.fontColor = .black
        hometButton.position = CGPoint(x: self.size.width/2 , y: 150)
        hometButton.name = " homeButton "
        self.addChild(hometButton)
        
        
        let startButton = SKSpriteNode(imageNamed: "buttonRetry")

//        startButton.text = " START "
//        startButton.fontColor = .black
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
