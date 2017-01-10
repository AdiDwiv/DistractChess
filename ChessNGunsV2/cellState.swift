//
//  cellState.swift
//  ChessNGunsV2
//
//  Created by Aditya Dwivedi on 11/24/16.
//  Copyright © 2016 org.cuappdev.project. All rights reserved.
//

import Foundation

class cellState {

    var pieceOnCell: GamePiece?
    var canMoveTo : Bool
    
    init() {
        pieceOnCell = nil
        canMoveTo = false
    }
    
    func setPiece(piece: GamePiece)  {
        pieceOnCell = piece
    }
    
    func moveTo(cell: cellState) {
            cell.pieceOnCell = pieceOnCell
            pieceOnCell = nil
        
    }
    func changeMoveStatus() {
        pieceOnCell?.hasMoved = true
    }
    
    func hasPiece() -> Bool {
        return pieceOnCell != nil
    }

}
