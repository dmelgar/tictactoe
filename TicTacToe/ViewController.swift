//
//  ViewController.swift
//  TicTacToe
//
//  Created by David Melgar on 2/8/15.
//  Copyright (c) 2015 Broad Reach Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        while false {
            print(".")
            testBestMove()
        }
    }

    func testBestMove() {
        var board = Board()
        board.board = [
            .C, .C, .E,
            .P, .E, .E,
            .P, .E, .E]
        nextMoveEvaluation(board, moveSet: [2], testcase: 1)
        
        // Winning game sequence.
        board.board = [
            .E, .P, .E,
            .E, .C, .E,
            .E, .E, .E]
        nextMoveEvaluation(board, moveSet: [0, 2], testcase: 10)
        board.board = [
            .C, .P, .E,
            .E, .C, .E,
            .E, .E, .P]
        nextMoveEvaluation(board, moveSet: [3, 6], testcase: 11)
        board.board = [
            .C, .P, .P,
            .E, .C, .E,
            .C, .E, .P]
        nextMoveEvaluation(board, moveSet: [3], testcase: 12)
    }
    
    func nextMoveEvaluation(board: Board, moveSet: [Int], testcase: Int) {
        let engine = TTTEngine()
        let bestMove = engine.findMaxMove(board)
        let result = find(moveSet, bestMove.move)
        println("TestBestMove/nextMoveEvalutation Testcase: \(testcase) Move: \(bestMove.move) Score: \(bestMove.score)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

