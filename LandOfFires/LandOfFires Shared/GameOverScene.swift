//
//  GameOverScene.swift
//  LandOfFires iOS
//
//  Created by antonia on 12/12/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        
        super.init(size: size)
        self.backgroundColor = .blue
        
        let label = SKLabelNode(fontNamed: "Cochin")
        label.text = " GAME OVER "
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        self.addChild(label)
        
        
        let menuButton = SKLabelNode(fontNamed: "Cochin")
        menuButton.text = " MENU "
        menuButton.fontColor = .black
        menuButton.position = CGPoint(x: self.size.width/2 , y: 80)
        menuButton.name = " menuButton "
        self.addChild(menuButton)
        
        
        let replayButton = SKLabelNode(fontNamed: "Cochin")
        replayButton.text = " RETRY "
        replayButton.fontColor = .black
        replayButton.position = CGPoint(x: self.size.width/2 , y: 50)
        replayButton.name = " REPLAY "
        self.addChild(replayButton)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            
            if node?.name == " REPLAY " {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            } else if node?.name == " menuButton "{
                    let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
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
