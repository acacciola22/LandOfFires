//
//  CreditsScene.swift
//  LandOfFires iOS
//
//  Created by Rita Marrano on 15/12/22.
//


import Foundation
import SpriteKit

class MenuScene: SKScene {
    
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
        label.text = " The Land Of Fires "
        label.fontSize = 80
        label.fontColor = .black
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 40)
        self.addChild(label)
        

        //STARTBUTTON
        let startButton = SKSpriteNode(imageNamed: "buttonStart")
        startButton.setScale(3.5)
        startButton.position = CGPoint(x: self.size.width/2 , y: 140)
        startButton.name = " startButton "
        self.addChild(startButton)
        
        
        //SCORES BUTTON
        let scoreButton = SKSpriteNode(imageNamed: "buttonScore")
        scoreButton.setScale(3.5)
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
        let creditsButton = SKSpriteNode(imageNamed: "credits")
        creditsButton.setScale(3.5)
        creditsButton.position = CGPoint(x: self.size.width - 50, y: 50)
        creditsButton.name = " buttonCredits "
        self.addChild(creditsButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            if (node?.name == " startButton ") {
                run(buttonSound)
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }else if (node?.name == " buttonScore "){
                run(buttonSound)
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = ScoreScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }else if (node?.name == " buttonHow ") {
                run(buttonSound)
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = HowToPlayScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }else if (node?.name == " buttonCredits ") {
                run(buttonSound)
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = CreditsScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition:  reveal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init")
    }
}

