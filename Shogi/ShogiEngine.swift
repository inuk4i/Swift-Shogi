//
//  ShogiEngine.swift
//  Shogi
//
//  Created by ikelab on 2020/09/04.
//  Copyright © 2020年 ikelab. All rights reserved.
//

import Foundation

struct ShogiEngine{
    var fieldPieces = Set<ShogiPiece>()
    var holdingPieces = Set<ShogiPiece>()
    var topTurn: Bool = false
    
    var numOfHoldingPiecesInTop = 0
    var numOfHoldingPiecesInBottom = 0
    
    mutating func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int){
        
    
        
        guard let candidate = pieceAt(col: fromCol, row: fromRow) else {
            print(false)
            return
        }
        print("\(fromCol),\(fromRow)")
        print(candidate.isPieceInField)
        if candidate.isPieceInField{
            if !canMovePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) {
                return
            }
            
            // take enemy piece and moving my holding field
            if let target = pieceAt(col: toCol, row: toRow){
                if target.isTop == candidate.isTop{
                    return
                }
                fieldPieces.remove(target)
                // whether holding piece have a same piece as target.rank
                var NotFindInHoldingPiece = true
                for piece in holdingPieces{
                    if piece.rank == target.rank && piece.isTop != target.isTop{
                        let targetPiece :ShogiPiece = ShogiPiece(col: piece.col, row: piece.row, imageName1: target.imageName1, imageName2: target.imageName2, isTop: !target.isTop, rank: target.rank, num: piece.num + 1, isPieceInField: piece.isPieceInField)
                        // !isTop
                        holdingPieces.remove(piece)
                        holdingPieces.insert(targetPiece)
                        NotFindInHoldingPiece = false
                    }
                }
                print(NotFindInHoldingPiece)
                if NotFindInHoldingPiece{
                    if !target.isTop{
                        let targetPiece :ShogiPiece = ShogiPiece(col: numOfHoldingPiecesInTop-1, row: -1, imageName1: target.imageName1, imageName2: target.imageName2, isTop: !target.isTop, rank: target.rank, num: 1, isPieceInField: false)
                        numOfHoldingPiecesInTop = numOfHoldingPiecesInTop + 1
                        holdingPieces.insert(targetPiece)
                    }else{
                        let targetPiece :ShogiPiece = ShogiPiece(col: 8-(numOfHoldingPiecesInBottom-1), row: 9, imageName1: target.imageName1, imageName2: target.imageName2, isTop: !target.isTop, rank: target.rank, num: 1, isPieceInField: false)
                        numOfHoldingPiecesInBottom = numOfHoldingPiecesInBottom + 1
                        holdingPieces.insert(targetPiece)
                    }
                    
                    
                }
            }
            //
            fieldPieces.remove(candidate)
            fieldPieces.insert(ShogiPiece(col: toCol, row: toRow, imageName1: candidate.imageName1, imageName2: candidate.imageName2, isTop: candidate.isTop, rank: candidate.rank, num: 1, isPieceInField: candidate.isPieceInField))
        }else{
            if !canMoveFromHoldingPiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow){
                return
            }
            print(holdingPieces)
            if candidate.num == 1{
                holdingPieces.remove(candidate)
                numOfHoldingPiecesInTop = numOfHoldingPiecesInTop - 1
            }else{
                let targetPiece :ShogiPiece = ShogiPiece(col: candidate.col, row: candidate.row, imageName1: candidate.imageName1, imageName2: candidate.imageName2, isTop: candidate.isTop, rank: candidate.rank, num: candidate.num - 1, isPieceInField: false)
                holdingPieces.remove(candidate)
                holdingPieces.insert(targetPiece)
            }
            fieldPieces.insert(ShogiPiece(col: toCol, row: toRow, imageName1: candidate.imageName1, imageName2: candidate.imageName2, isTop: candidate.isTop, rank: candidate.rank, num: 1, isPieceInField: true))
            
        }
            topTurn = !topTurn
    }
    func canMoveFromHoldingPiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        if toCol < 0 || toCol > 8 || toRow < 0 || toRow > 8{
            return false
        }
        if fromCol == toCol && fromRow == toRow{
            return false
        }
        if pieceAtFieldPieces(col: toCol, row: toRow) != nil{
            return false
        }
            
        guard let candidate = pieceAtHoldingPieces(col: fromCol, row: fromRow) else {
            return false
        }
        if candidate.isTop != topTurn {
            return false
        }
        if !candidate.isPieceInField{
            if pieceAtFieldPieces(col: candidate.col, row: candidate.row) != nil{
                return false
            }
            return true
        }
        return false
    }
        
    
    
    
    func canMovePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        if toCol < 0 || toCol > 8 || toRow < 0 || toRow > 8{
            return false
        }
        if fromCol == toCol && fromRow == toRow{
            return false
        }
        guard let candidate = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        if candidate.isTop != topTurn {
            return false
        }
        switch candidate.rank {
        case .knight:
            return canMoveKnight(fromCol:fromCol, fromRow:fromRow, toCol: toCol, toRow: toRow)
        case .pawn:
            return canMovePawn(fromCol:fromCol, fromRow:fromRow, toCol: toCol, toRow: toRow)
        case .bishop:
            return canMoveBishop(fromCol:fromCol, fromRow:fromRow, toCol: toCol, toRow: toRow)
        case .rook:
            return canMoveRook(fromCol:fromCol, fromRow:fromRow, toCol: toCol, toRow: toRow)
        case .lance:
            return canMoveLance(fromCol:fromCol, fromRow:fromRow, toCol: toCol, toRow: toRow)
        case .gold:
            return canMoveGold(fromCol:fromCol, fromRow:fromRow, toCol: toCol, toRow: toRow)
        case .silver:
            return canMoveSilver(fromCol:fromCol, fromRow:fromRow, toCol: toCol, toRow: toRow)
        case .king:
            return canMoveKing(fromCol:fromCol, fromRow:fromRow, toCol: toCol, toRow: toRow)
        default:
            return true
        }
        
    }
    
    
    func canMovePawn(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        if fromCol == toCol && abs(fromRow - toRow) == 1{
            return true
        }
        return false
    }
    func canMoveBishop(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        guard emptyBetween(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) else{
            return false
        }
        if abs(fromCol - toCol) == abs(fromRow - toRow){
            return true
        }
        return false
    }
    func canMoveRook(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        guard emptyBetween(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) else{
            return false
        }
        if (fromCol == toCol || fromRow == toRow){
            return true
        }
        return false
    }
    func canMoveKnight(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        guard let movingKnight = pieceAt(col: fromCol, row: fromRow) else{
            return false
        }
        if movingKnight.isTop{
            if abs(fromCol - toCol) == 1 && toRow - fromRow == 2{
                return true
            }
            return false
        }else{
            if abs(fromCol - toCol) == 1 &&  fromRow - toRow == 2{
                return true
            }
            return false
        }
    }
    
    func canMoveLance(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        guard let movingLance = pieceAt(col: fromCol, row: fromRow) else{
            return false
        }
        if movingLance.isTop{
            if fromCol == toCol && toRow - fromRow  > 0{
                return true
            }
            return false
        }else{
            if fromCol == toCol &&  fromRow - toRow > 0{
                return true
            }
            return false
        }
    }
    func canMoveGold(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        guard let movingGold = pieceAt(col: fromCol, row: fromRow) else{
            return false
        }
        if abs(fromCol - toCol) < 2 &&  abs(fromRow - toRow) < 2{
            if movingGold.isTop{
                if abs(fromCol - toCol) == 1 && fromRow - toRow == 1{
                    return false
                }
                return true
            }else{
                if abs(fromCol - toCol) == 1 && fromRow - toRow == -1{
                    return false
                }
                return true
            }
            
        }
        return false
    }
    func canMoveSilver(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        guard let movingSilver = pieceAt(col: fromCol, row: fromRow) else{
            return false
        }
        if abs(fromCol - toCol) < 2 &&  abs(fromRow - toRow) < 2{
            if abs(fromCol - toCol) == 1 && abs(fromRow - toRow) == 0{
                return false
            }
            if movingSilver.isTop{
                if fromCol == toCol && fromRow - toRow == 1{
                    return false
                }
                return true
            }else{
                if fromCol == toCol && fromRow - toRow == -1{
                    return false
                }
                return true
            }
            
        }
        return false
    }
    func canMoveKing(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        if abs(fromCol - toCol) < 2 &&  abs(fromRow - toRow) < 2{
            return true
        }
        return false
    }
    
    func emptyBetween(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool{
        if fromRow == toRow{
            let minCol = min(fromCol, toCol)
            let maxCol = max(fromCol, toCol)
            if maxCol - minCol < 2 {
                return true
            }
            for i in minCol + 1 ... maxCol - 1{
                if pieceAt(col: i, row: fromRow) != nil{
                    return false
                }
            }
            return true
        }else if fromCol == fromRow{
            let minRow = min(fromRow, toRow)
            let maxRow = max(fromRow, toRow)
            
            if maxRow - minRow < 2 {
                return true
            }
            for i in minRow + 1 ... maxRow - 1{
                if pieceAt(col: fromCol, row: i) != nil{
                    return false
                }
            }
            return true
        }else if abs(fromCol - toCol) == abs(fromRow - toRow){
            // top left and bottom right \
            let minCol = min(fromCol, toCol)
            let maxCol = max(fromCol, toCol)
            let maxRow = max(fromRow, toRow)
            let minRow = min(fromRow, toRow)
            if  fromCol - toCol == fromRow - toRow{
                
                if maxCol - minCol < 2 {
                    return true
                }
                for i in  1 ..< maxCol - minCol{
                    if pieceAt(col: minCol + i, row: minRow + i) != nil{
                        return false
                    }
                }
                return true
            }else if fromCol - toCol == -(fromRow - toRow){// bottom left and top right /
                
                if maxCol - minCol < 2 {
                    return true
                }
                for i in 1 ..< maxCol - minCol{
                    if pieceAt(col: minCol + i, row: maxRow - i) != nil{
                        return false
                    }
                }
                return true
            }
            
        }
        
        return false
    }
    func pieceAt(col: Int, row:Int) -> ShogiPiece?{
        for piece in fieldPieces{
            if col == piece.col && row == piece.row{
                return piece;
            }
        }
        print(holdingPieces)
        for piece in holdingPieces{
            print("\(col), \(row), \(piece.row), \(piece.col)")
            if col == piece.col && row == piece.row{
                return piece;
            }
        }
        return nil
    }
    
    func pieceAtFieldPieces(col: Int, row:Int) -> ShogiPiece?{
        for piece in fieldPieces{
            if col == piece.col && row == piece.row{
                return piece;
            }
        }
        return nil
    }
 
    func pieceAtHoldingPieces(col: Int, row:Int) -> ShogiPiece?{
        for piece in holdingPieces{
            if col == piece.col && row == piece.row{
                return piece;
            }
        }
        return nil
    }
 
    
    mutating func initializeGame(){
        topTurn = false
        fieldPieces.removeAll()
        holdingPieces.removeAll()
        
        fieldPieces.insert(ShogiPiece(col: 4, row: 0, imageName1: "sgsk01", imageName2: "None", isTop: true, rank: .king, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 4, row: 8, imageName1: "sgsk01", imageName2: "None", isTop:false, rank: .king, num: 1, isPieceInField: true))
        for i in 0..<2{
        fieldPieces.insert(ShogiPiece(col: 3 + i*2, row: 0, imageName1: "sgsg01", imageName2: "None", isTop: true, rank: .gold, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 3 + i*2, row: 8, imageName1: "sgsg01", imageName2: "None", isTop:false, rank:.gold, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 2 + i*4, row: 0, imageName1: "sgss01", imageName2: "None", isTop: true, rank: .silver, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 2 + i*4, row: 8, imageName1: "sgss01", imageName2: "None", isTop:false, rank: .silver, num: 1, isPieceInField: true))
        
        fieldPieces.insert(ShogiPiece(col: 1 + i*6, row: 0, imageName1: "sgsn01", imageName2: "None", isTop: true, rank: .knight, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 1 + i*6, row: 8, imageName1: "sgsn01", imageName2: "None", isTop:false, rank: .knight, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 0 + i*8, row: 0, imageName1: "sgsl01", imageName2: "None", isTop: true, rank: .lance, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 0 + i*8, row: 8, imageName1: "sgsl01", imageName2: "None", isTop:false, rank: .lance, num: 1, isPieceInField: true))
        
        }
        fieldPieces.insert(ShogiPiece(col: 1, row: 1, imageName1: "sgsr01", imageName2: "None", isTop:true, rank: .rook, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 7, row:  1, imageName1: "sgsb01", imageName2: "None", isTop:true, rank: .bishop, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 7, row: 7, imageName1: "sgsr01", imageName2: "None", isTop:false, rank: .rook, num: 1, isPieceInField: true))
        fieldPieces.insert(ShogiPiece(col: 1, row: 7, imageName1: "sgsb01", imageName2: "None", isTop:false, rank: .bishop, num: 1, isPieceInField: true))
    
        
        for i in 0..<9 {
            fieldPieces.insert(ShogiPiece(col: i, row: 2, imageName1: "sgsp01", imageName2: "None", isTop:true, rank: .pawn, num: 1, isPieceInField: true))
            fieldPieces.insert(ShogiPiece(col: i, row: 6, imageName1: "sgsp01", imageName2: "None", isTop:false, rank: .pawn, num: 1, isPieceInField: true))
            }
    }
}
