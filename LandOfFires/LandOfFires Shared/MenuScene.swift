//
//  MenuScene.swift
//  LandOfFires iOS
//
//  Created by antonia on 12/12/22.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    override init(size: CGSize) {
        
        super.init(size: size)
        self.backgroundColor = .blue
        
        let label = SKLabelNode(fontNamed: "Cochin")
        label.text = " The Land Of Fires "
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        self.addChild(label)
        
        
        let startButton = SKLabelNode(fontNamed: "Cochin")
        startButton.text = " START "
        startButton.fontColor = .black
        startButton.position = CGPoint(x: self.size.width/2 , y: 50)
        startButton.name = " startButton "
        self.addChild(startButton)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            if node?.name == " startButton " {
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
