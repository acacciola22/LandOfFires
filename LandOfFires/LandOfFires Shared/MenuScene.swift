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
      
        for index in 0..<2 {
            let bg = SKSpriteNode(imageNamed: "background")
            bg.position = CGPoint(x: index * Int(bg.size.width), y: 0)
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.name = "background"
            
            self.addChild(bg)
        }
        
        
        //TITLE
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: self.size.width/2, y: self.size.height/2+55)
        logo.setScale(1.5)
        logo.size = CGSize(width: 500, height: 100)
        logo.name = "logo"
        
        let logo1 = SKTexture(imageNamed: "logo1")
        let logo2 = SKTexture(imageNamed: "logo2")
        let logo3 = SKTexture(imageNamed: "logo3")
        let logo4 = SKTexture(imageNamed: "logo4")
        let logo5 = SKTexture(imageNamed: "logo5")
        let logo6 = SKTexture(imageNamed: "logo6")
        
        
                logo.run(SKAction.repeatForever(
                    SKAction.animate(with: [logo1, logo2, logo3, logo4, logo5, logo6],
                                     timePerFrame: 0.3,
                                     resize: false,
                                     restore: true)),
                         withKey:"iconAnimate")
        self.addChild(logo)
        

        //STARTBUTTON
        let startButton = SKSpriteNode(imageNamed: "buttonStart")
        startButton.setScale(3.0)
        startButton.position = CGPoint(x: self.size.width/2 , y: 140)
        startButton.name = " startButton "
        self.addChild(startButton)
        
        
        //SCORES BUTTON
        let scoreButton = SKSpriteNode(imageNamed: "buttonScore")
        scoreButton.setScale(3.0)
        scoreButton.position = CGPoint(x: self.size.width/2 , y: 60)
        scoreButton.name = " buttonScore "
        self.addChild(scoreButton)
        
        
        //HOW PLAY BUTTON
        let playButton = SKSpriteNode(imageNamed: "howplay")
        playButton.setScale(2.5)
        playButton.position = CGPoint(x: self.size.width - 50, y: 330)
        playButton.name = " buttonHow "
        self.addChild(playButton)
        
        
        //CREDITS BUTTON
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            if (node?.name == " startButton ") {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }else if (node?.name == " buttonScore "){
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = ScoreScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }else if (node?.name == " buttonHow ") {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = HowToPlayScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init")
    }
}

