
//
//  CreditsScene.swift
//  Merdina
//
//  Created by Rita Marrano on 14/12/22.
//

import Foundation
import SpriteKit

class CreditsScene: SKScene {
    let buttonSound = SKAction.playSoundFileNamed("bottone", waitForCompletion: false)
    override init(size: CGSize) {
        
        super.init(size: size)
      
        for index in 0..<2 {
            let bg = SKSpriteNode(imageNamed: "background")
            bg.position = CGPoint(x: index * Int(bg.size.width), y: 0)
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.name = "background"
            
            self.addChild(bg)
        }
        
        
        //TITLE
        let label = SKLabelNode(fontNamed: "2Credits")
        label.text = " CIAO SIAMO LE WINX AAEGR "
        label.fontSize = 60
        label.fontColor = .black
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
                run(buttonSound)
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

