//
//  PauseScene.swift
//  LandOfFires iOS
//
//  Created by Rita Marrano on 15/12/22.
//

import Foundation
import SpriteKit

class PauseScene: SKScene {
    
    override init(size: CGSize) {
        
        super.init(size: size)
      
        backgroundColor = .black
        
        
        //TITLE
        let label = SKLabelNode(fontNamed: "2Credits")
        label.text = " Pause "
        label.fontSize = 60
        label.fontColor = .white
        label.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        self.addChild(label)
        

        // BACKBUTTON
        let backButton = SKSpriteNode(imageNamed: "buttonBack")
        backButton.setScale(2.5)
        backButton.position = CGPoint(x: self.size.width - 50, y: 330)
        backButton.name = " backButton "
        self.addChild(backButton)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            if (node?.name == " backButton ") {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init")
    }
}

