//
//  Distract.swift
//  Chess
//
//  Created by Aditya Dwivedi on 1/8/17.
//  Copyright © 2017 org.cuappdev.project. All rights reserved.
//

import Foundation
import AVFoundation

class Distract  {
    var fibonacciSequencer: [Int] = [1,2]
    var fiveSequencer: Int = 5
    var elevenSequencer: Int = 11
    var twoExponentSequencer: Int = 4
    var randomRanger: Int = 0
    var scareRanger: Int = 0
    
    var backgroundImage: [String]
    var boardBackground: [String]
    var pieceImage: [String]
    var deathScreamSet: [String] = []
    var alpha: CGFloat!
    var soundEffect: AVAudioPlayer!
    
    /* Returns random number from set [start,end)
     */
    func randomize(start: Int, end: Int) -> Int {
        return start+Int(arc4random_uniform(UInt32(end-start)))
    }
    
    init() {
        backgroundImage = []
        boardBackground = []
        pieceImage = []
        var tempString = "backgroundPattern"
        var i = 0
        while i <= 22 {
            backgroundImage.append(tempString+String(i))
            i += 1
        }
        i = 0
        tempString = "boardBackground"
        while i <= 13 {
            boardBackground.append(tempString+String(i))
            i += 1
        }
        i = 2
        tempString = "set"
        while i <= 3 {
            pieceImage.append(tempString+String(i))
            i += 1
        }
        i = 1
        tempString = "scream"
        while i <= 4{
            deathScreamSet.append(tempString+String(i))
            i += 1
        }
    }
    
    /* Returns a [n/ backgroundImage,n/ boardImageWhite, n/ pieceImageSet]
     */
    func distractifyUI(turn: Int) -> [String?] {
        var returnArray: [String?] = [nil,nil,nil]
        if randomRanger == 0 {
            randomRanger = randomize(start: 1, end: 11)
        }
        switch turn {
        case twoExponentSequencer:
            returnArray[0] = backgroundImage[randomize(start: 0, end: backgroundImage.count)]
            returnArray[1] = boardBackground[randomize(start: 0, end: boardBackground.count)]
            returnArray[2] = pieceImage[randomize(start: 0, end: pieceImage.count)]
            twoExponentSequencer *= 2
            break
            
        case fiveSequencer:
            returnArray[0] = backgroundImage[randomize(start: 0, end: backgroundImage.count)]
            fiveSequencer += 5
            fallthrough
            
        case elevenSequencer:
            returnArray[1] = boardBackground[randomize(start: 0, end: boardBackground.count)]
            elevenSequencer += 11
            fallthrough
            
        case fibonacciSequencer[1]:
            returnArray[1] = boardBackground[randomize(start: 0, end: boardBackground.count)]
            returnArray[2] = pieceImage[randomize(start: 0, end: pieceImage.count)]
            let temp = fibonacciSequencer[1]
            fibonacciSequencer[1] = fibonacciSequencer[0] + temp
            fibonacciSequencer[0] = temp
            fallthrough
        
        case randomRanger:
            randomRanger += randomize(start: 1, end: 11)
            let changeIndex = randomize(start: 0, end: 3)
            switch changeIndex {
            case 0:
                returnArray[0] = backgroundImage[randomize(start: 0, end: backgroundImage.count)]
                break
            case 1:
                returnArray[1] = boardBackground[randomize(start: 0, end: boardBackground.count)]
                break
            default:
                returnArray[2] = pieceImage[randomize(start: 0, end: pieceImage.count)]
            }
        default: break
        }
        return returnArray
    }
    
    
    func getRandomAlpha()  {
        let n = CGFloat(randomize(start: 8, end: 12)) * 0.1
        print(n)
        if n > 1 {
            alpha = 1.0
        }
        alpha = n
    }
    
    func playDeathScream() {
        let soundName = deathScreamSet[randomize(start: 0, end: deathScreamSet.count)]
        let soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        
        do {
                let sound = try AVAudioPlayer(contentsOf: soundURL)
                soundEffect = sound
        } catch {
            print(error.localizedDescription)
        }
        soundEffect.play()
    }
}
