//
//  ViewController.swift
//  Shogi
//
//  Created by ikelab on 2020/09/04.
//  Copyright © 2020年 ikelab. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ShogiDelegate{
    
    
    var shogiEngine :ShogiEngine = ShogiEngine()
    
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        boardView.shogiDelegate = self
        shogiEngine.initializeGame()
        boardView.shadowPieces = shogiEngine.fieldPieces
        boardView.setNeedsDisplay()
    }
    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        updateMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
    }
    func updateMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int){
        shogiEngine.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        boardView.shadowPieces = shogiEngine.fieldPieces
        boardView.holdingPieces = shogiEngine.holdingPieces
        boardView.setNeedsDisplay()
        //
        //if shogiEngine.whitesTurn{
        //    infoLabel.text = "White"
        //}else{
        //    infoLabel.text = "Black"
        //}
        if shogiEngine.topTurn{
            infoLabel.text = "後手"
        }else{
            infoLabel.text = "先手"
        }
        
    }
    func pieceAt(col: Int, row: Int) -> ShogiPiece? {
        return shogiEngine.pieceAt(col: col, row: row)
    }
    
    func pieceAtFieldPieces(col: Int, row: Int) -> ShogiPiece? {
        return shogiEngine.pieceAtFieldPieces(col: col, row: row)
    }
    func pieceAtHoldingPieces(col: Int, row: Int) -> ShogiPiece? {
        return shogiEngine.pieceAtHoldingPieces(col: col, row: row)
    }
}
