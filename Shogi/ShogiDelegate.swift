//
//  ShogiDelegate.swift
//  Shogi
//
//  Created by ikelab on 2020/09/05.
//  Copyright © 2020年 ikelab. All rights reserved.
//

import Foundation

protocol ShogiDelegate {
    func movePiece(fromCol:Int, fromRow: Int, toCol: Int, toRow:Int)
    func pieceAt(col: Int, row:Int) -> ShogiPiece?
    func pieceAtFieldPieces(col: Int, row:Int) -> ShogiPiece?
    func pieceAtHoldingPieces(col: Int, row:Int) -> ShogiPiece?
}
