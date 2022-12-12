//
//  ScoreScene.swift
//  LandOfFires iOS
//
//  Created by Rita Marrano on 12/12/22.
//

import Foundation
import SpriteKit

class ScoreScene : SKScene {
    
    var score : Int = 0
    
    override func didMove(to view: SKView) -> Void {
        
        let scores = loadScores()
        var height = frame.height - 55
        let width = frame.width/2
        
        let titleNode : SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        titleNode.text = "HIGH SCORES"
        titleNode.fontColor = .purple
        titleNode.position.y = height
        height -= 30
        titleNode.position.x = width
        addChild(titleNode)
        
        
        for index in scores.indices
        {
            let rank = "\(index + 1): \(scores[index])"
            let scoreNode : SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Light")
            scoreNode.text = rank
            scoreNode.position.y = height
            scoreNode.position.x = width
            if index % 2 == 0
            {
                scoreNode.fontColor = .magenta
            }
            else
            {
                scoreNode.fontColor = .green
            }
            
            height -= 30
            addChild(scoreNode)
        }
        
    let personalScoreNode = SKLabelNode(fontNamed: "Copperplate-Light")
        personalScoreNode.text = "your score: \(score)"
        personalScoreNode.position.y = height
        personalScoreNode.position.x = width + 10
        personalScoreNode.fontColor = .yellow
        addChild(personalScoreNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first != nil)
        {
            goToEndGame()
        }
    }
    
    private func goToEndGame() -> Void{
        let transition = SKTransition.doorway(withDuration: 10)
        let restartScene = GameOverScene(size: size)
//        restartScene.gameScore = score
//        restartScene.size = CGSize(width: 300, height: 400)
        restartScene.scaleMode = .fill
        self.view?.presentScene(restartScene, transition: transition)
    }
}
