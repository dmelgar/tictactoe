//
//  TTTBoardView.swift
//  TicTacToe
//
//  Created by David Melgar on 2/9/15.
//  Copyright (c) 2015 Broad Reach Software. All rights reserved.
//

import UIKit

protocol TTTBoardViewDelegate {
    func playerMoved(_ playerMove: Int)
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
    
    override func draw(_ rect: CGRect) {
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
        UIColor.black.set()
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2.0)
        
        // Draw pieces on the board
        for move in 0...8 {
            switch board.board[move] {
            case .p:
                // X
                strokes += drawX(move)
            case .c:
                drawO(move, context: context)
            default: ()
            }
        }
        
        for stroke in strokes {
            context.move(to:CGPoint(x:stroke[0], y:stroke[1]))
            context.addLine(to:CGPoint(x:stroke[2], y:stroke[3]))
            context.strokePath()
        }
        // Test draw O
        // drawO(4, squareSize: squareSize, context: context)
    }
    
    // Returns array of strokes. Each stroke has 4 coordinates, start x, y, end x, y
    func drawX(_ position: Int) -> [[CGFloat]] {
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
        return strokes
    }
    
    func drawO(_ position: Int, context: CGContext) {
        let xStrokes = drawX(position)
        let stroke = xStrokes[0]
        let rect = CGRect(x: stroke[0], y: stroke[1],
            width: stroke[2] - stroke[0],  // width
            height: stroke[2] - stroke[0])  // height
        context.addEllipse(in: rect)
        context.strokePath()
    }
    
    // Handle touch
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Ignore multi-touch
        // let touches = event!.allTouches() as? Set<UITouch>
        if touches.count == 1 {
            if let point = touches.first?.location(in: self) {
                // Figure out which square the touch is in
                let playerMove = convertPointToSquare(point)
                // Let the listener know
                delegate?.playerMoved(playerMove)
            }
        }
    }
    
    // Convert point to square
    func convertPointToSquare(_ point: CGPoint) -> Int {
        let col: Int = Int(point.x / squareSize)
        let row: Int = Int(point.y / squareSize)
        let square = row * 3 + col
        if true {
            print("TTTBoardView.convertPointToSquare square:\(square)")
        }
        return square
    }
}
