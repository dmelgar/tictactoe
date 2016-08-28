//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by David Melgar on 2/8/15.
//  Copyright (c) 2015 Broad Reach Software. All rights reserved.
//

import UIKit
import XCTest

class TicTacToeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Do TTD. Set of test cases that grow
    func testForWinTopRow() {
        let board = Board()
        board.board = [.c, .c, .c, .e, .e, .e,  .e, .e, .e]
        XCTAssert(board.hasWon(.c), "Pass")
    }
    
    func testWinLeftCol() {
        let board = Board()
        board.board = [
            .c, .p, .p,
            .c, .e, .e,
            .c, .p, .p]
        XCTAssertTrue(board.hasWon(.c), "Pass")
    }
    
    func testNotWin() {
        let board = Board()
        board.board = [.c, .c, .p, .e, .e, .e,  .e, .e, .e]
        XCTAssert(!board.hasWon(.c), "Pass")
    }
    
    func testDraw() {
        let board = Board()
        board.board = [.p, .p, .c,  .c, .c, .p,  .p, .c, .c]
        XCTAssert(board.isDraw(), "Pass")
        XCTAssert(!board.hasWon(.c), "Pass")
    }
    
    func testMinMove() {
        let board = Board()
        let engine = TTTEngine()
        board.board = [
            .p, .p, .e,
            .e, .c, .c,
            .c, .e, .e]
        _ = engine.findBestMove(board, player: .p)
        // let result = engine.findMinMove(board)
        // XCTAssertFalse(find([2], result.move) == nil, "Fail move=\(result.move) score=\(result.move)")
    }
    
    func testBestMove() {
        self.measure({
            let board = Board()
            board.board = [
                .c, .c, .e,
                .p, .e, .e,
                .p, .e, .e]
            self.nextMoveEvaluation(board, moveSet: [2], testcase: 1)
            
            // Winning game sequence.
            board.board = [
                .e, .p, .e,
                .e, .c, .e,
                .e, .e, .e]
            self.nextMoveEvaluation(board, moveSet: [0, 2], testcase: 10)
            board.board = [
                .c, .p, .e,
                .e, .c, .e,
                .e, .e, .p]
            self.nextMoveEvaluation(board, moveSet: [3, 6], testcase: 11)
            board.board = [
                .c, .p, .p,
                .e, .c, .e,
                .c, .e, .p]
            self.nextMoveEvaluation(board, moveSet: [3], testcase: 12)
        })
    }
    
    func nextMoveEvaluation(_ board: Board, moveSet: [Int], testcase: Int) {
        let engine = TTTEngine()
        // let bestMove = engine.findMaxMove(board)
        let bestMove = engine.findBestMove(board, player: .c)
        let result = moveSet.index(of: bestMove.move)
        // let result = find(moveSet, bestMove.move)
        print("TestBestMove/nextMoveEvalutation Testcase: \(testcase) Move: \(bestMove.move) Score: \(bestMove.score)")
        XCTAssertFalse(result == nil, "Fail testcase=\(testcase)")
        // XCTAssert(result != nil, "Pass")
    }
}
