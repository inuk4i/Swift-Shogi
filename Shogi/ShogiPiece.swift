//
//  ShogiPiece.swift
//  Shogi
//
//  Created by ikelab on 2020/09/04.
//  Copyright © 2020年 ikelab. All rights reserved.
//

import Foundation

struct ShogiPiece: Hashable{
    let col: Int
    let row: Int
    let imageName1: String
    let imageName2: String
    var isTop: Bool
    let rank: ShogiRank
    var num: Int
    var isPieceInField: Bool 
}
