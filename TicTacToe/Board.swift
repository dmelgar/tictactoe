//
//  TTTEngine.swift
//  TicTacToe
//
//  Created by David Melgar on 2/8/15.
//  Copyright (c) 2015 Broad Reach Software. All rights reserved.
//

import Foundation

class Board {
    init() {}
    
    init(copy: Board) {
        board = copy.board
    }
    
    enum PositionState {
        case C // Computer
        case P // Player
        case E // Empty. Or should I use nil as empty?
    }
    
    enum BoardState {
        case CWon
        case PWon
        case Draw
        case Invalid
        case Valid
    }
    
    // Note that setting board is set by value, ie a copy is made of the array
    var board: [PositionState] = [PositionState](count: 9, repeatedValue: .E)
    
    func move(newMove: Int, player: PositionState) -> BoardState {
        var result: BoardState = .Valid
        if !isValidMove(newMove) {
            result = .Invalid
        } else {
            board[newMove] = player
            if isDraw() {
                result = .Draw
            } else if hasWon(.C) {
                result = .CWon
            } else if hasWon(.P) {
                result = .PWon
            }
        }
        return result
    }
    
    func hasWon(player: PositionState) -> Bool {
        let winningPatterns = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
            [1, 4, 7],
            [2, 5, 8],
            [3, 6, 9],
            [1, 5, 9],
            [3, 5, 7]]
        // Iterate through winning patterns
        var hasWon = true
        var index = 0
        for pattern in winningPatterns {
            hasWon = true
            for i in pattern {
                hasWon = hasWon && (board[i-1] == player)
                if !hasWon {
                    break
                }
            }
            if hasWon == true {
                break
            }
        }
        return hasWon
    }
    
    func isDraw() -> Bool {
        var result = true
        for i in 0...8 {
            if board[i] == .E {
                result = false
                break
            }
        }
        return result
    }
    
    func isValidMove(move: Int) -> Bool {
        return board[move] == .E
    }
}
