//
//  EnemyType.swift
//  LandOfFires iOS
//
//  Created by antonia on 12/12/22.
//

import SpriteKit

struct EnemyType: Codable {
    let name: String
    let shields: Int
    let speed: CGFloat
    let powerUpChance: Int
}

