//
//  TTTEngine.swift
//  TicTacToe
//
//  Created by David Melgar on 2/8/15.
//  Copyright (c) 2015 Broad Reach Software. All rights reserved.
//

import Foundation

var debug = false

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
    
//    func move(newMove: Int, player: PositionState) {
//        board[newMove] = player
//    }
    
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

protocol TTTEngineDelegate {
    func computerMove(position: Int, status: Board.BoardState)
}

class TTTEngine {
    // Define data structures

    var board = Board()
    var delegate: TTTEngineDelegate?
    var state: Board.BoardState = .Valid
    
    //
    func playerMove(position: Int) {
        board.move(position, player: .P)
        dispatch_async(DISPATCH_QUEUE_PRIORITY_BACKGROUND, {
            let computerMove = self.findBestMove(board, player: .C)
        })
    }
    
    // Utility methods for scoring
    // Way to workaround inability of Swift 1.1 to initialize a non-optional variable to one of two values
    // In Swift 1.2, released 2/9/2015, this is no longer required
    private func worstScore(player: Board.PositionState) -> Int {
        if player == .C {
            return -200
        } else {
            return 200
        }
    }
    
    private func wonScore(player: Board.PositionState) -> Int {
        if player == .C {
            return 100
        } else {
            return -100
        }
    }
    
    private func getOpponentBestMove(player: Board.PositionState, board: Board, depth: Int = 0) -> (move: Int, score: Int) {
        if player == .C {
            return findBestMove(board, player: .P, depth: depth + 1)
        } else {
            return findBestMove(board, player: .C, depth: depth + 1)
        }
    }
    
    private func isBetterScore(player: Board.PositionState, score: Int, bestScore: Int) -> Bool {
        if player == .C {
            return score > bestScore
        } else {
            return score < bestScore
        }
    }
    
    func findBestMove(board: Board, player: Board.PositionState, depth: Int = 0) -> (move: Int, score: Int) {
        if debug {
            println("FindBestMove")
        }
        var bestScore: Int = worstScore(player)
        var bestMove: Int = -1          // No move yet
        for move in 0...8 {
            var score = worstScore(player)
            if board.isValidMove(move) {
                var subBoard = Board(copy: board)
                subBoard.board[move] = player
                if subBoard.hasWon(player) {
                    score = wonScore(player)
                } else if subBoard.isDraw() {
                    score = 0
                } else {
                    score = getOpponentBestMove(player, board: subBoard, depth: depth + 1).score
                }
            }
            if debug {
                println("FindMinMove Depth: \(depth) Move: \(move) Score: \(score) BestScore: \(bestScore)")
            }
            if isBetterScore(player, score: score, bestScore: bestScore) {
                bestScore = score
                bestMove = move
                if bestScore == wonScore(player) {
                    break   // Winning move, no need to try other moves
                }
            }
        }
        if debug {
            println("FindMinMove Depth: \(depth) Best move: \(bestMove) Best score: \(bestScore)")
        }
        return (bestMove, bestScore)
    }
}