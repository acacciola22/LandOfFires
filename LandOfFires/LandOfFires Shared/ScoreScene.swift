//
//  ScoreScene.swift
//  LandOfFires iOS
//
//  Created by Rita Marrano on 12/12/22.
//

import Foundation
import SpriteKit

class ScoreScene : SKScene {
    let buttonSound = SKAction.playSoundFileNamed("bottone", waitForCompletion: false)
    var score : Int = 0
    
    override func didMove(to view: SKView) -> Void {
        
        
        // BACKBUTTON
        let backButton = SKSpriteNode(imageNamed: "buttonBack")
        backButton.setScale(2.5)
        backButton.position = CGPoint(x: self.size.width - 50, y: 330)
        backButton.name = " backButton "
        self.addChild(backButton)
        
        
        let scores = loadScores()
        var height = frame.height - 55
        let width = frame.width/2
        

        
        let titleNode : SKLabelNode = SKLabelNode(fontNamed: "STV5730A")
        titleNode.text = "HIGH SCORES"
        titleNode.fontSize = 30
        titleNode.fontColor = .gray
        titleNode.position.y = height
        height -= 40
        titleNode.position.x = width
        addChild(titleNode)
        
        
        for index in scores.indices
        {
            let rank = "\(index + 1): \(scores[index])"
            let scoreNode : SKLabelNode = SKLabelNode(fontNamed: "STV5730A")
            scoreNode.text = rank
            scoreNode.position.y = height
            scoreNode.position.x = width
            if index % 2 == 0
            {
                scoreNode.fontColor = .white
            }
            else
            {
                scoreNode.fontColor = .black
            }
            
            height -= 30
            addChild(scoreNode)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            if (node?.name == " backButton ") {
                run(buttonSound)
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = MenuScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }
        }
    }
}
