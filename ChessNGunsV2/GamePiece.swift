//
//  GamePiece.swift
//  ChessNGunsV2
//
//  Created by Aditya Dwivedi on 11/24/16.
//  Copyright © 2016 org.cuappdev.project. All rights reserved.
//

import Foundation
import UIKit

class GamePiece {
    
    var pieceImage: UIImage?
    var team: Int
    var pieceCode: Int
    var hasMoved: Bool
    var pieceName: String!
    
    init(team: Int, code: Int) {
        self.team = team
        pieceImage = UIImage()
        pieceCode = code
        hasMoved = false
        pieceName = "Piece"
    }
    
    func setImage(imageName: String) {
        if team == 1 {
            pieceImage = UIImage(named: imageName+"White")
        }
        else {
            pieceImage = UIImage(named: imageName+"Black")
        }
    }
}

class Pawn: GamePiece {
    
     init(team: Int) {
        super.init(team: team, code: 1)
        pieceName = "Pawn"
    }
    override func setImage(imageName: String) {
        super.setImage(imageName: imageName+"Pawn")
    }
}

class Knight: GamePiece {
    
    init(team: Int) {
        super.init(team: team, code: 2)
        pieceName = "Knight"
    }
    override func setImage(imageName: String) {
        super.setImage(imageName: imageName+"Knight")
    }
}

class Rook: GamePiece {
    
    init(team: Int) {
        super.init(team: team, code: 4)
        pieceName = "Rook"
    }
    override func setImage(imageName: String) {
        super.setImage(imageName: imageName+"Rook")
    }

}

class Bishop: GamePiece {
    
    init(team: Int) {
        super.init(team: team, code: 5)
        pieceName = "Bishop"
    }
    override func setImage(imageName: String) {
        super.setImage(imageName: imageName+"Bishop")
    }

}

class Queen: GamePiece {
    
    init(team: Int) {
        super.init(team: team, code: 3)
        pieceName = "Queen"
    }
    override func setImage(imageName: String) {
        super.setImage(imageName: imageName+"Queen")
    }

}
class King: GamePiece {
    
    init(team: Int) {
        super.init(team: team, code: 0)
        pieceName = "King"
    }
    override func setImage(imageName: String) {
        super.setImage(imageName: imageName+"King")
    }

}
