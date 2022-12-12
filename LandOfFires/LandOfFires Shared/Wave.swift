//
//  Wave.swift
//  LandOfFires iOS
//
//  Created by antonia on 12/12/22.
//

import SpriteKit

struct Wave: Codable {
    struct WaveEnemy: Codable {
        let position: Int
        let xOffset: CGFloat
        let moveStraight: Bool
    }

    let name: String
    let enemies: [WaveEnemy]
}
