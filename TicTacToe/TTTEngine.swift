//
//  TTTEngine.swift
//  TicTacToe
//
//  Created by David Melgar on 2/8/15.
//  Copyright (c) 2015 Broad Reach Software. All rights reserved.
//

import Foundation

var debug = false

protocol TTTEngineDelegate {
    func computerMove(_ position: Int, status: Board.BoardState)
}

class TTTEngine {
    // Define data structures

    var board = Board()
    var delegate: TTTEngineDelegate?
    var state: Board.BoardState = .valid
    
    //
    func playerMove(_ position: Int) {
        _ = board.move(position, player: .p)
        
        DispatchQueue.global(qos:.background).async {
            _ = self.findBestMove(self.board, player: .c)
        }
    }
    
    // Utility methods for scoring
    // Way to workaround inability of Swift 1.1 to initialize a non-optional variable to one of two values
    // In Swift 1.2, released 2/9/2015, this is no longer required
    fileprivate func worstScore(_ player: Board.PositionState) -> Int {
        if player == .c {
            return -200
        } else {
            return 200
        }
    }
    
    fileprivate func wonScore(_ player: Board.PositionState) -> Int {
        if player == .c {
            return 100
        } else {
            return -100
        }
    }
    
    fileprivate func getOpponentBestMove(_ player: Board.PositionState, board: Board, depth: Int = 0) -> (move: Int, score: Int) {
        if player == .c {
            return findBestMove(board, player: .p, depth: depth + 1)
        } else {
            return findBestMove(board, player: .c, depth: depth + 1)
        }
    }
    
    fileprivate func isBetterScore(_ player: Board.PositionState, score: Int, bestScore: Int) -> Bool {
        if player == .c {
            return score > bestScore
        } else {
            return score < bestScore
        }
    }
    
    func findBestMove(_ board: Board, player: Board.PositionState, depth: Int = 0) -> (move: Int, score: Int) {
        if debug {
            print("FindBestMove")
        }
        var bestScore: Int = worstScore(player)
        var bestMove: Int = -1          // No move yet
        for move in 0...8 {
            var score = worstScore(player)
            if board.isValidMove(move) {
                let subBoard = Board(copy: board)
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
                print("FindMinMove Depth: \(depth) Move: \(move) Score: \(score) BestScore: \(bestScore)")
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
            print("FindMinMove Depth: \(depth) Best move: \(bestMove) Best score: \(bestScore)")
        }
        return (bestMove, bestScore)
    }
}
