//
//  Utilities.swift
//  LandOfFires iOS
//
//  Created by Rita Marrano on 12/12/22.
//

import Foundation

func updateHighScore(with score : Int) -> Void {
    var newScores = loadScores()
    newScores.append(score)
    newScores.sort()
    newScores.reverse()
    
    if (newScores.count == 11) {
        newScores.remove(at: newScores.count - 1)
    }
    
    UserDefaults.standard.set(newScores, forKey: "drop game high score")
}

func loadScores()->[Int] {
    
    var scores : [Int] = [0]
    
    if let rawData = UserDefaults.standard.object(forKey: "drop game high score"){
        if let savedScores = rawData as? [Int]{
            scores = savedScores
        }
        
    }
    scores.sort()
    scores.reverse()
    return scores
}
