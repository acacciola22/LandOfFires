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
    
    for i in newScores{
        if !newScores.contains(i){
            newScores.append(i)
        }
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

//extension Array where Element:Equatable {
//    func removeDuplicates() -> [Element] {
//        var result = [Element]()
//
//        for value in self {
//            if result.contains(value) == false {
//                result.append(value)
//            }
//        }
//
//        return result
//    }
//}



//extension Array where Element: Hashable {
//    func uniquelements() -> Array {
//        var temp = Array()
//        var s = Set<Element>()
//        for i in self {
//            if !s.contains(i) {
//                temp.append(i)
//                s.insert(i)
//            }
//        }
//        return temp
//    }
//}
//var a=[1,2,3,4,4,4,1,5,4,6,7,6]
//var x = a.uniquelements()
//print(x)


