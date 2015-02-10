//
//  TTTBoardView.swift
//  TicTacToe
//
//  Created by David Melgar on 2/9/15.
//  Copyright (c) 2015 Broad Reach Software. All rights reserved.
//

import UIKit

protocol TTTBoardViewDelegate {
    func playerMoved(playerMove: Int)
}

class TTTBoardView: UIView {
    
    // Normally don't want to mix the model and view, but this view needs to maintain state
    // to redraw. Needs to remember X, O, E for each position. Thats what the Board class
    // does
    var board: Board = Board()
    var delegate: TTTBoardViewDelegate?
    
    // Calculate locations of lines
    var side: CGFloat = 0
    var squareSize: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        // Calculate locations of lines
        let width = bounds.width
        let height = bounds.height
        side = min(width, height)
        squareSize = side/3

        var strokes = [[CGFloat]]() // Array. Each element has 4 coordinates, start x,y, end x, y
        
        for i in 1...2 {
            // Draw vertical line
            var x: CGFloat = squareSize * CGFloat(i)
            var y: CGFloat = 0
            var endX: CGFloat = x
            var endY: CGFloat = side
            strokes.append([x, y, endX, endY])
            
            // Draw horizontal line
            x = 0
            y = squareSize * CGFloat(i)
            endX = side
            endY = y
            strokes.append([x, y, endX, endY])
        }
        
        // Test draw a center X
        // strokes += drawX(5, squareSize: squareSize)
        
        // Drawing code
        // Draw a TTT board
        UIColor.blackColor().set()
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        
        // Draw pieces on the board
        for move in 0...8 {
            switch board.board[move] {
            case .P:
                // X
                strokes += drawX(move)
            case .C:
                drawO(move, context: context)
            default: ()
            }
        }
        
        for stroke in strokes {
            CGContextMoveToPoint(context, stroke[0], stroke[1]) // x,y
            CGContextAddLineToPoint(context, stroke[2], stroke[3]) // x, y
            CGContextStrokePath(context)
        }
        // Test draw O
        // drawO(4, squareSize: squareSize, context: context)
    }
    
    // Returns array of strokes. Each stroke has 4 coordinates, start x, y, end x, y
    func drawX(position: Int) -> [[CGFloat]] {
        var strokes = [[CGFloat]]()
        // Or add to array
        let row = position/3
        let col = position % 3
        let padding: CGFloat = 10
        
        let startX = padding + CGFloat(col) * squareSize
        let endX   = startX + squareSize - 2 * padding
        
        let startY = padding + CGFloat(row) * squareSize
        let endY   = startY + squareSize - 2 * padding
        
        strokes.append([startX, startY, endX, endY])
        strokes.append([endX, startY, startX, endY])
        println(strokes)
        return strokes
    }
    
    func drawO(position: Int, context: CGContextRef) {
        let xStrokes = drawX(position)
        let stroke = xStrokes[0]
        let rect = CGRectMake(stroke[0], stroke[1],
            stroke[2] - stroke[0],  // width
            stroke[2] - stroke[0])  // height
        CGContextAddEllipseInRect(context, rect)
        CGContextStrokePath(context)
    }
    
    // Handle touch
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Ignore multi-touch
        let touches = event.allTouches() as? Set<UITouch>
        if touches?.count == 1 {
            if let point = touches?.first?.locationInView(self) {
                // Figure out which square the touch is in
                let playerMove = convertPointToSquare(point)
                // Let the listener know
                delegate?.playerMoved(playerMove)
            }
        }
    }
    
    // Convert point to square
    func convertPointToSquare(point: CGPoint) -> Int {
        let col: Int = Int(point.x / squareSize)
        let row: Int = Int(point.y / squareSize)
        let square = row * 3 + col
        if true {
            println("TTTBoardView.convertPointToSquare square:\(square)")
        }
        return square
    }
}
