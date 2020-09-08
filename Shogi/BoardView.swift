//
//  BoardView.swift
//  Shogi
//
//  Created by ikelab on 2020/09/04.
//  Copyright © 2020年 ikelab. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    let splitCount = 11
    var shadowPieces: Set<ShogiPiece> = Set<ShogiPiece>()
    var holdingPieces: Set<ShogiPiece> = Set<ShogiPiece>()
    var shogiDelegate: ShogiDelegate? = nil
    
    var fromCol:Int? = nil
    var fromRow:Int? = nil
    
    var width: CGFloat = -1
    var height: CGFloat = -1
    
    var movingImage: UIImage? = nil
    var movingPieceX: CGFloat = -1
    var movingPieceY: CGFloat = -1
    
    var isMovingPieceInField: Bool = true
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 1.5
    
        UIColor.black.setStroke()
        for x in 0...splitCount {
            for y in 0...splitCount {
                if x != y, x == 0, 0 < y ,y < splitCount {
                    path.move(to: getPoint(rect, x: CGFloat(x+1), y: CGFloat(y)))
                    path.addLine(to: getPoint(rect, x: CGFloat(splitCount-1), y: CGFloat(y)))
                    path.stroke()
                } else if   x < splitCount, x != 0, y == 0 {
                    path.move(to: getPoint(rect, x: CGFloat(x), y: CGFloat(y+1)))
                    path.addLine(to: getPoint(rect, x: CGFloat(x), y: CGFloat(splitCount-1)))
                    path.stroke()
                }
            }
        }
        drawPieces()
    }
    func drawPieces() {
        for piece in shadowPieces where !(fromCol == piece.col && fromRow == piece.row){
            var pieceImage = UIImage(named: piece.imageName1)
            if piece.isTop {
                pieceImage = InverseImage(pieceImage!)
            }
            pieceImage?.draw(in: CGRect(x:width + CGFloat(piece.col) * width, y: height + CGFloat(piece.row) * height, width: width, height: height))
        }
        movingImage?.draw(in: CGRect(x: movingPieceX - width/2, y: movingPieceY - height/2 , width: width, height: height))
        
        // draw holding pieces
        //for (index, piece) in zip(holdingPieces.indices, holdingPieces){
        for piece in holdingPieces  where !(fromCol == piece.col && fromRow == piece.row){
            var pieceImage = UIImage(named: piece.imageName1)
            if piece.isTop {
                pieceImage = InverseImage(pieceImage!)
                //pieceImage?.draw(in: CGRect(x:1+CGFloat(index.hashValue)*width, y: 0, width: width, height: height))
            }
            print(piece.row)
            pieceImage?.draw(in: CGRect(x:CGFloat(1 + piece.col)*width, y: CGFloat(piece.row+1) * height, width: width, height: height))
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let fingerLocation = first.location(in: self)
        fromCol = Int((fingerLocation.x  ) / width) - 1
        fromRow = Int((fingerLocation.y ) / height) - 1
        
       // can find piece at (from, col) in field to get the image
        if let fromCol = fromCol, let fromRow = fromRow, let movingPiece = shogiDelegate?.pieceAt(col:fromCol, row:fromRow){
            movingImage = UIImage(named: movingPiece.imageName1)
            if movingPiece.isTop{
                movingImage = InverseImage(movingImage!)
            }
        }
       
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let fingerLocation = first.location(in: self)
        movingPieceX = fingerLocation.x
        movingPieceY = fingerLocation.y
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let fingerLocation = first.location(in: self)
        let toCol:Int = Int((fingerLocation.x  ) / width) - 1
        let toRow:Int = Int((fingerLocation.y ) / height) - 1
        
        if let fromCol = fromCol, let fromRow = fromRow, !(toCol == fromCol && toRow == fromRow ){
            shogiDelegate?.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        }
        
        movingImage = nil
        fromCol = nil
        fromRow = nil
    }
    
    
        /* View上の指定した区画の座標を取得 */
    private func getPoint(_ rect: CGRect, x: CGFloat, y: CGFloat) -> CGPoint {
            width = rect.width / CGFloat(splitCount)
            height = rect.height / CGFloat(splitCount)
            return CGPoint(x: width * x, y: height * y)
        }
    private func InverseImage(_ image: UIImage) -> UIImage {
        
        let imgSize = CGSize.init(width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: image.size.width/2, y: image.size.height/2)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let radian: CGFloat =  CGFloat.pi
        context.rotate(by: radian)
        
        context.draw(image.cgImage!, in: CGRect.init(x: -image.size.width/2, y: -image.size.height/2, width: image.size.width, height: image.size.height))
        
        let rotatedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}


