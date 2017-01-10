//
//  GameGridViewController.swift
//  ChessNGunsV2
//
//  Created by Aditya Dwivedi on 11/24/16.
//  Copyright © 2016 org.cuappdev.project. All rights reserved.
//

import UIKit
import AVFoundation

class GameGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /* Internal class which stores the state of the game at any point of time
     */
    class BoardStatus {
        var turn: Int // 1 is white, 2 is black
        var turnCount: Int // Counts the number of turns that have been played
        var status: Int // 0 means a piece has not been selected. 1 means a piece has been selected.
        var hasWon: Int // Stores the winner of the game
        
        var king1: Int // Stores the position
        var king2: Int // of the kings King1 is white, King2 is black
        var kingChecked: Int
        var teamChecking: Int // 1 is white 2 is black
        var teamCheckingPerm: Int // stores original value for a turn as the original changes
        var checker: Int // Position of checking piece
        
        
        var cellChosen: cellState! // Cell chosen by user
        var cellChosenIndex: Int // Index of cellChosen
        var possibleMoveIndices = Set<Int>() // Set of possible moves
        
        init() {
            turn  = 1
            turnCount = 0
            status = 0
            hasWon = -1
            king1 = -1
            king2 = -1
            kingChecked = -1
            checker = -1
            cellChosenIndex = -1
            teamChecking = 0
            teamCheckingPerm = 0
        }
        
        //Functions for moving
        
        //Adds possible move to the set
        func addPossibleMove(moveIndex: Int)  {
            possibleMoveIndices.insert(moveIndex)
        }
        //Removes move from set
        func removeMove(moveIndex: Int) {
            possibleMoveIndices.remove(moveIndex)
        }
        // Returns size of set
        func countPossibles() -> Int {
            return possibleMoveIndices.count
        }
        // Checks if given index lies within set
        func canMoveTo(index: Int) -> Bool {
            return possibleMoveIndices.contains(index)
        }
        //Moves piece from cellChosen to parameter cell
        func moveTo(cell: cellState, index: Int) {
            cellChosen.moveTo(cell: cell)
            
            if let pieceAtCell = cell.pieceOnCell {
                if pieceAtCell.pieceCode == 0 {
                    if pieceAtCell.team == 1 { king1 = index }
                    else { king2 = index }
                }
            }

        }
        // Moves piece from parameter cell to cellChosen
        func moveBack(cell: cellState) {
            cell.moveTo(cell: cellChosen)
            
            if let pieceAtCell = cellChosen.pieceOnCell {
                if pieceAtCell.pieceCode == 0 {
                    if pieceAtCell.team == 1 { king1 = cellChosenIndex }
                    else { king2 = cellChosenIndex }
                }
            }
            
        }
        // Retruns code of opposing team
        func getOpposingTeam() -> Int {
            if let pieceAtCell = cellChosen.pieceOnCell {
                if pieceAtCell.team == 1 {
                    return -1
                }
                return 1
            }
            return 0
        }
        // Empties set
        func clearPossibleMoves() {
            possibleMoveIndices.removeAll()
        }
        
        //Functions for checks
        func getEnemyKing(piece: GamePiece) -> Int {
            if piece.team == 1 {
                return king2
            }
            return king1
        }
        // Returns index of own king
        func getOwnKing(piece: GamePiece) -> Int {
            if piece.team == 1 {
                return king1
            }
            return king2
        }
        // Returns the team whose king is checked
        func getCheckedTeam() -> Int {
            if kingChecked == king1 {
                return 1
            }
            else if kingChecked == king2 {
                return -1
            }
            return 0
        }
        // Checks a king
        func check(KingChecked: Int, Checker: Int) {
            kingChecked = KingChecked
            checker = Checker
        }
        // Returns true if there is a check
        func isCheck() -> Bool {
            return checker != -1
        }
        // Resets check related variables
        func resetCheck() {
            checker = -1
            kingChecked = -1
        }
    }
    
    var gameCollectionView: UICollectionView!
    
    var boardStates: [cellState] = [] // Stores states of each square in game
    var boardStatus: BoardStatus! // BoardStatus object
    var distracter: Distract! // Distract object responsible for UIChanges
    var uiSet: [String] = ["backgroundPattern0", "boardBackground0", "set2"] // Stores current UI elements
    
    var turnLabel: UILabel! // Displays color of the turn and the piece selected
    var checkLabel: UILabel! // Displays checks
    
    //var hasCollectionView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        initBoard()
        distracter = Distract()
        distracter.getRandomAlpha()
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: view.frame.width*0.25, left: view.frame.width*0.05, bottom: view.frame.width*0.01, right: view.frame.width*0.05)

        layout.minimumInteritemSpacing = 0
        gameCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        gameCollectionView.center.x = view.center.x
        gameCollectionView.center.y = view.frame.height*0.5
        gameCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: uiSet[0])!)
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        gameCollectionView.register(gameCollectionViewCell.self, forCellWithReuseIdentifier: "Reuse")
        view.addSubview(gameCollectionView)
        
        
        turnLabel = UILabel(frame: CGRect(x: 0, y: view.frame.width*1.30, width: view.frame.width*0.40, height: view.frame.height*0.050))
        turnLabel.center.x = view.center.x
        turnLabel.text = "None Selected"
        turnLabel.textColor = .black
        turnLabel.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        turnLabel.textAlignment = NSTextAlignment.center
        turnLabel.font = UIFont.systemFont(ofSize: 17)
        turnLabel.minimumScaleFactor = 0.1
        turnLabel.adjustsFontSizeToFitWidth = true
        turnLabel.layer.cornerRadius = 15
        view.addSubview(turnLabel)
        
        checkLabel = UILabel(frame: CGRect(x: 0, y: view.frame.width*0.185, width: view.frame.width*0.35, height: view.frame.height*0.065))
        checkLabel.center.x = view.center.x
        checkLabel.textAlignment = NSTextAlignment.center
        checkLabel.text = ""
        checkLabel.textColor = .white
        checkLabel.font = UIFont.boldSystemFont(ofSize: 20)
        checkLabel.minimumScaleFactor = 0.1
        checkLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(checkLabel)
        
        navigationController?.isNavigationBarHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       }
    
    /* Initializes board with pieces
    */
    func initBoard() {
        boardStatus = BoardStatus()
        
        var i = 0
        while i<64 {
            boardStates.append(cellState())
            i += 1
        }
        
        i = 0
        while i<8 {
            boardStates[8+i].setPiece(piece: Pawn(team: 1))
            boardStates[48+i].setPiece(piece: Pawn(team: -1))
            
            switch i {
            case 0: fallthrough
            case 7: boardStates[i].setPiece(piece: Rook(team: 1))
                    boardStates[56+i].setPiece(piece: Rook(team: -1))
                    break
            case 1: fallthrough
            case 6: boardStates[i].setPiece(piece: Knight(team: 1))
                    boardStates[56+i].setPiece(piece: Knight(team: -1))
                    break
            case 5: fallthrough
            case 2: boardStates[i].setPiece(piece: Bishop(team: 1))
                    boardStates[56+i].setPiece(piece: Bishop(team: -1))
                    break
            case 3: boardStates[i].setPiece(piece: Queen(team: 1))
                    boardStates[56+i].setPiece(piece: Queen(team: -1))
                break
            case 4: boardStates[i].setPiece(piece: King(team: 1))
                boardStatus.king1 = i
                boardStates[56+i].setPiece(piece: King(team: -1))
                boardStatus.king2 = 56+i
                break
            default:
                break
            }
            i += 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (view.frame.width*0.9)/8
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardStates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: "Reuse", for: indexPath) as! gameCollectionViewCell
        
        if cell.hasImage() {
            cell.removeImage()
        }
        if cell.hasBack() {
            cell.removeBackground()
        }
        cell.backgroundColor = .white
        
        let tempArr = distracter.distractifyUI(turn: boardStatus.turnCount)
        for i in [0,1,2] {
            if let uiName = tempArr[i] {
                uiSet[i] = uiName
            }
        }
        gameCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: uiSet[0])!)
        
        var boardBackImageName = ""
        var backgroundImage = UIImage()
        
        let rowId = indexPath.row-(indexPath.row%8)
        //var squareId = false // true for black false for white
        if rowId%16 == 0 {
            if indexPath.row%2 == 0 {
                boardBackImageName = uiSet[1]+"White"
                backgroundImage = UIImage(named: boardBackImageName)!
            }
            else {
                boardBackImageName = uiSet[1]+"Black"
                backgroundImage = UIImage(named: boardBackImageName)!
               // squareId = true
            }

        }
        else {
            if indexPath.row%2 == 0 {
                boardBackImageName = uiSet[1]+"Black"
                backgroundImage = UIImage(named: boardBackImageName)!
               // squareId = true
            }
            else {
                boardBackImageName = uiSet[1]+"White"
                backgroundImage = UIImage(named: boardBackImageName)!
            }

        }
        //Displays pieces
        if let pieceAtCell = boardStates[indexPath.row].pieceOnCell {
                pieceAtCell.setImage(imageName: uiSet[2])
                cell.setImage(image: pieceAtCell.pieceImage!)
            }
        //Displays possible move locations
        if boardStatus.status == 1 {
            if boardStatus.canMoveTo(index: indexPath.row) {
                //cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 10.0, alpha: 0.5)
               backgroundImage = UIImage(named: boardBackImageName+"Mover")!
            }
        }
        cell.backgroundColor = UIColor.white.withAlphaComponent(0)
        backgroundImage = backgroundImage.opacity(alpha: distracter.alpha)
        cell.setBackground(image: backgroundImage)
        return cell
    }
    
    /* Chooses cell
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if boardStatus.status == 0 {
            if let pieceAtCell = boardStates[indexPath.row].pieceOnCell {
                
                if pieceAtCell.team == boardStatus.turn {
                   selectPiece(indexPath: indexPath, pieceAtCell: pieceAtCell)
                }
            }
        }
        else if boardStatus.status == 1 {
            
            if boardStatus.canMoveTo(index: indexPath.row) {
                if boardStates[indexPath.row].hasPiece() {
                    distracter.playDeathScream()
                }
                boardStatus.moveTo(cell: boardStates[indexPath.row], index: indexPath.row)
                boardStates[indexPath.row].changeMoveStatus()
                
                nextTurn()
            }
            else {
                moveFinishedOrCancelled()
                if let pieceAtCell = boardStates[indexPath.row].pieceOnCell {
                    
                    if pieceAtCell.team == boardStatus.turn {
                        selectPiece(indexPath: indexPath, pieceAtCell: pieceAtCell)
                        }
                }
            }
        }
    }
    
    /* Selects piece at chosen cell
    */
    func selectPiece(indexPath: IndexPath, pieceAtCell: GamePiece) {
        boardStatus.cellChosen = boardStates[indexPath.row]
        boardStatus.cellChosenIndex = indexPath.row
        getMovesforPiece(piece: pieceAtCell, position: indexPath.row)
        moveWithoutCheck(cell: boardStatus.cellChosen)
        turnLabel.text = pieceAtCell.pieceName+" selected"
        boardStatus.status = 1
        gameCollectionView.reloadData()
    }
    
    /* Called when a turn ends
     */
    func nextTurn() {
        
        checkForChecks()
        boardStatus.teamCheckingPerm = boardStatus.teamChecking
        distracter.getRandomAlpha()
        
        if boardStatus.turn == 1 {
            boardStatus.turn = -1
            turnLabel.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            turnLabel.textColor = .white
        }
        else {
            boardStatus.turn = 1
            turnLabel.backgroundColor = UIColor.white.withAlphaComponent(0.85)
            turnLabel.textColor = .black
        }
        
        checkLabel.text = ""
        checkLabel.backgroundColor = UIColor.red.withAlphaComponent(0)
        if boardStatus.isCheck() {
            checkLabel.text = " Check"
            checkLabel.backgroundColor = UIColor.red.withAlphaComponent(0.9)
        }
        
        if boardStatus.isCheck() {
            checkForMate()
        }
        boardStatus.turnCount += 1
        moveFinishedOrCancelled()
    }

    func moveFinishedOrCancelled() {
        turnLabel.text = "None selected"
        boardStatus.clearPossibleMoves()
        boardStatus.status = 0
        
        gameCollectionView.reloadData()
    }
    
    /* Adds possible moves for chosen piece to boardStatus.possibleMoves
     */
    func getMovesforPiece(piece: GamePiece, position: Int) {
        
        boardStatus.clearPossibleMoves()
        
        switch piece.pieceCode {
            
        case 1: let forwardSquare = position + (8 * piece.team)
                var moves: [Int] = []
                moves.append(forwardSquare)
        
                if !piece.hasMoved && !boardStates[forwardSquare].hasPiece() {
                   moves.append(forwardSquare + (8 * piece.team))
                }
                if boardStates[forwardSquare-1].hasPiece() && forwardSquare%8 != 0 {
                    moves.append(forwardSquare-1)
                }
                if boardStates[forwardSquare+1].hasPiece() && (forwardSquare+1)%8 != 0 {
                    moves.append(forwardSquare+1)
                }
        
                for i in moves {
                    if boardStates[i].hasPiece() {
                        if i != forwardSquare && i != (forwardSquare+(8*piece.team)) {
                            if let pieceAtCell = boardStates[i].pieceOnCell {
                                if pieceAtCell.team != piece.team {
                                    boardStatus.addPossibleMove(moveIndex: i)
                                }
                            }
                        }
                    }
                    else { boardStatus.addPossibleMove(moveIndex: i) }
                }
        
                break
            
        case 2: let upDown = [position + 17, position + 15, position - 15, position - 17]
                var rightLeft = [position+10, position-6, position+6, position-10]
                if position%8 == 1 {
                    rightLeft.remove(at: 3)
                    rightLeft.remove(at: 2)
                }
                for i in upDown {
                    if i <= 63 && i >= 0 {
                        if position % 8 == 0 {
                            if  i != position+15  && i != position-17 {
                                addMove(i: i, piece: piece)
                            }
                        }
                        else if (position+1) % 8 == 0 {
                            if i != position+17 && i != position-15 {
                                addMove(i: i, piece: piece)
                            }
                        }
                        else {
                            addMove(i: i, piece: piece)
                        }
                    }
                }
        
                for j in rightLeft {
                    if j <= 63 && j >= 0 {
                        if position%8 <= 1 {
                            if j != position+6 && j != position-10 {
                                addMove(i: j, piece: piece)
                            }
                        }
                        if position%8 >= 6 {
                            if j != position+10 && j != position-6 {
                                addMove(i: j, piece: piece)
                            }
                        }
                        else {
                           addMove(i: j, piece: piece)
                        }
                    }
                }
        
                break
        case 3: fallthrough
        case 4: var i = position+8
                while i < 64 {
                    if addMoveWithBreak(i: i, piece: piece) {
                        break
                    }
                    i += 8
                }
        
                i = position-8
                while i >= 0 {
                    if addMoveWithBreak(i: i, piece: piece) {
                        break
                    }
                    i -= 8
                }
        
                i = position+1
                while i%8 != 0 {
                    if addMoveWithBreak(i: i, piece: piece) {
                        break
                    }
                    i += 1
                }
        
                i = position-1
                while (i+1)%8 != 0 {
                    if addMoveWithBreak(i: i, piece: piece) {
                        break
                    }
                    i -= 1
                }
        
                if(piece.pieceCode != 3){
                    break
                }
                fallthrough
        case 5: var i = position
        
                if (position+1)%8 != 0 {
                    i = position+9
                    while i < 64 {
                        if addMoveWithBreak(i: i, piece: piece) {
                            break
                        }
                        if i%8 == 0 || (i+1)%8 == 0 {
                                break
                            }
                        i += 9
                        }

                    i = position-7
                    while i >= 0 {
                        if addMoveWithBreak(i: i, piece: piece) {
                            break
                        }
                        if i%8 == 0 || (i+1)%8 == 0 {
                            break
                        }
                        i -= 7
                    }
                }
        
                if position%8 != 0 {
                    i = position-9
                    while i >= 0 {
                        if addMoveWithBreak(i: i, piece: piece) {
                            break
                        }
                        if i%8 == 0 || (i+1)%8 == 0 {
                            break
                        }
                        i -= 9
                    }
                    
                    i = position+7
                    while i < 64 {
                        if addMoveWithBreak(i: i, piece: piece) {
                            break
                        }
                        if i%8 == 0 || (i+1)%8 == 0 {
                            break
                        }
                        
                        i += 7
                    
                    }
                }
        
               break
            
        case 0: let moves = [8, -8, 1, -1, 7, -7, 9, -9]
                for j in moves {
                    let i = position+j
                    if i < 64 && i >= 0 {
                        if position%8 == 0  {
                            if (j != -1 && j != -9 && j != 7){
                                addMove(i: i, piece: piece)
                                 }
                        }
                        else if (position+1)%8 == 0  {
                            if (j != 1 && j != 9 && j != -7) {
                                addMove(i: i, piece: piece)
                             }
                        }
                        else {
                            addMove(i: i, piece: piece)
                        }
                    }
                }
                break
        default:
                break
        }
    }
    
    /* Adds index i to possible moves for piece
     */
    func addMove(i: Int, piece: GamePiece) {
        if boardStates[i].hasPiece() {
            if let pieceAtCell = boardStates[i].pieceOnCell {
                if pieceAtCell.team != piece.team  {
                    boardStatus.addPossibleMove(moveIndex: i)
                }
            }
        }
        else { boardStatus.addPossibleMove(moveIndex: i) }
    }
    /* Adds index i to possible moves for piece (with breaks)
     */
    func addMoveWithBreak(i: Int, piece: GamePiece) -> Bool {
        if boardStates[i].hasPiece() {
            if let pieceAtCell = boardStates[i].pieceOnCell {
                if pieceAtCell.team != piece.team {
                    boardStatus.addPossibleMove(moveIndex: i)
                }
                return true
            }
        }
        else { boardStatus.addPossibleMove(moveIndex: i) }
        return false
    }
    /* Checks if any king is checked
     */
    func checkForChecks(){
        boardStatus.resetCheck()
        var i = 0
        while i < boardStates.count {
            
            if let piece = boardStates[i].pieceOnCell {
                getMovesforPiece(piece: piece, position: i)
                
                let enemyKing = boardStatus.getEnemyKing(piece: piece)
                
                if boardStatus.canMoveTo(index: enemyKing) {
                    boardStatus.check(KingChecked: enemyKing, Checker: i)
                    boardStatus.teamChecking = piece.team
                    break
                }
            }
            boardStatus.teamChecking = 0
            i += 1
        }
        boardStatus.clearPossibleMoves()
    }
    /* Removes those moves from possible moves set whoich would endanger the team's king
     */
    func moveWithoutCheck(cell: cellState) {
            var possibleMoveCopy = Set<Int>()
        
            let cellTemp = boardStatus.cellChosen
            boardStatus.cellChosen = cell
        
            for i in boardStatus.possibleMoveIndices {
                possibleMoveCopy.insert(i)
                var pieceProvisional :GamePiece? = nil
                
              
                if let piece = boardStates[i].pieceOnCell {
                    pieceProvisional = piece
                }
                if let pieceMoved = boardStatus.cellChosen.pieceOnCell {
                    boardStatus.moveTo(cell: boardStates[i], index: i)
                    checkForChecks()
                    if pieceMoved.team != boardStatus.teamCheckingPerm && boardStatus.isCheck() && boardStatus.teamCheckingPerm != 0 {
                        possibleMoveCopy.remove(i)
                    }
                    else if boardStatus.kingChecked == boardStatus.getOwnKing(piece: pieceMoved) {
                        possibleMoveCopy.remove(i)
                    }
                    
                    boardStatus.resetCheck()
                    boardStatus.moveBack(cell: boardStates[i])
                   
                    if let pieceReturned = pieceProvisional {
                        boardStates[i].setPiece(piece: pieceReturned)
                    }
                }
        }
            boardStatus.cellChosen = cellTemp
            boardStatus.possibleMoveIndices = possibleMoveCopy
    }
    /* Checks for mates
     */
    func checkForMate() {
        var possibleMoveCounter = 0
        let teamChecked = boardStatus.getCheckedTeam()
        var i = 0
        while i < boardStates.count {
            if let piece = boardStates[i].pieceOnCell {
                if piece.team == teamChecked {
                    getMovesforPiece(piece: piece, position: i)
                    flagg = true
                    moveWithoutCheck(cell: boardStates[i])
                    
                    if boardStatus.possibleMoveIndices.count > 0 {

                        possibleMoveCounter += 1
                        break
                    }
                }
            }
            i += 1
        }
        
        if possibleMoveCounter == 0 {
                checkLabel.text = " Checkmate"
           DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                let endViewController = GameEndViewController()
                endViewController.setString(winner: (-1*teamChecked))
                self.navigationController?.pushViewController(endViewController, animated: true)
            
            })
        }
        
    }
    
    var flagg: Bool = false

}

/* Extension for redrawing UIImage with given alpha
 */
extension UIImage {
    func opacity(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return returnImage!
    }
}
