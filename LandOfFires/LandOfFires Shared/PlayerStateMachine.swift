//
//  PlayerStateMachine.swift
//  LandOfFires iOS
//
//  Created by Rita Marrano on 12/12/22.
//

import Foundation
import GameplayKit

fileprivate let characteraAnimationKey = "playerjump"

class PlayerState: GKState {
    
    unowned var playerNode: SKNode
        
     init(playerNode : SKNode) {
        self.playerNode = playerNode
        super.init()
    }
}

class JumpingState : PlayerState {
    var hasFinishedJumping : Bool = false
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    
    override func didEnter(from previousState: GKState?) {
        
        hasFinishedJumping = false
        playerNode.run(.applyForce(CGVector(dx: 0, dy: 70), duration: 0.1))
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            self.hasFinishedJumping = true
        }
    }
}
