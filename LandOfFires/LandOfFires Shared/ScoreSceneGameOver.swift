//
//  ScoreSceneGameOver.swift
//  LandOfFires iOS
//
//  Created by Rita Marrano on 14/12/22.
//

import Foundation
import SpriteKit

class ScoreSceneGameOver : SKScene {
    
    var score : Int = 0
   
    
    override func didMove(to view: SKView) -> Void {
        
        var height = frame.height - 55
        let width = frame.width/2


        let titleNode : SKLabelNode = SKLabelNode(fontNamed: "STV5730A")
        titleNode.text = "GAME OVER BABY ! !"
        titleNode.fontSize = 30
        titleNode.fontColor = .gray
        titleNode.position.y = height
        height -= 40
        titleNode.position.x = width
        addChild(titleNode)

        let personalScoreNode = SKLabelNode(fontNamed: "STV5730A")
            personalScoreNode.text = "Your current score: \(score)"
            personalScoreNode.position.y = height
            personalScoreNode.position.x = width + 20
            personalScoreNode.fontColor = .white
            addChild(personalScoreNode)

        
        
        
        let hometButton = SKSpriteNode(imageNamed: "buttonHome")
        hometButton.setScale(2.5)
        hometButton.position = CGPoint(x: self.size.width/2 , y: 150)
        hometButton.name = " homeButton "
        self.addChild(hometButton)
        
        
        let startButton = SKSpriteNode(imageNamed: "buttonRetry")
        startButton.setScale(2.5)
        startButton.position = CGPoint(x: self.size.width/2 , y: 50)
        startButton.name = " REPLAY "
        self.addChild(startButton)
        
        
        


    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if (touches.first != nil)
//        {
//            goToEndGame()
//        }
//    }
    
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

    
    private func goToEndGame() -> Void{
        let transition = SKTransition.fade(withDuration: 4)
        let restartScene = GameOverScene(size: size)
//        restartScene.gameScore = score
//        restartScene.size = CGSize(width: 300, height: 400)
        restartScene.scaleMode = .fill
        self.view?.presentScene(restartScene, transition: transition)
    }
}
