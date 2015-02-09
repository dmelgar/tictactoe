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
        var board = Board()
        board.board = [.C, .C, .C, .E, .E, .E,  .E, .E, .E]
        XCTAssert(board.hasWon(.C), "Pass")
    }
    
    func testWinLeftCol() {
        var board = Board()
        board.board = [
            .C, .P, .P,
            .C, .E, .E,
            .C, .P, .P]
        XCTAssertTrue(board.hasWon(.C), "Pass")
    }
    
    func testNotWin() {
        var board = Board()
        board.board = [.C, .C, .P, .E, .E, .E,  .E, .E, .E]
        XCTAssert(!board.hasWon(.C), "Pass")
    }
    
    func testDraw() {
        var board = Board()
        board.board = [.P, .P, .C,  .C, .C, .P,  .P, .C, .C]
        XCTAssert(board.isDraw(), "Pass")
        XCTAssert(!board.hasWon(.C), "Pass")
    }
    
    func testIsValidMove() {
        XCTAssert(true, "Pass")
    }
    
    func testMinMove() {
        var board = Board()
        var engine = TTTEngine()
        board.board = [
            .P, .P, .E,
            .E, .C, .C,
            .C, .E, .E]
        let result = engine.findBestMove(board, player: .P)
        // let result = engine.findMinMove(board)
        XCTAssertFalse(find([2], result.move) == nil, "Fail move=\(result.move) score=\(result.move)")
    }
    
    func testBestMove() {
        self.measureBlock({
            var board = Board()
            board.board = [
                .C, .C, .E,
                .P, .E, .E,
                .P, .E, .E]
            self.nextMoveEvaluation(board, moveSet: [2], testcase: 1)
            
            // Winning game sequence.
            board.board = [
                .E, .P, .E,
                .E, .C, .E,
                .E, .E, .E]
            self.nextMoveEvaluation(board, moveSet: [0, 2], testcase: 10)
            board.board = [
                .C, .P, .E,
                .E, .C, .E,
                .E, .E, .P]
            self.nextMoveEvaluation(board, moveSet: [3, 6], testcase: 11)
            board.board = [
                .C, .P, .P,
                .E, .C, .E,
                .C, .E, .P]
            self.nextMoveEvaluation(board, moveSet: [3], testcase: 12)
        })
//        var board = Board()
//        board.board = [
//            .C, .C, .E,
//            .P, .E, .E,
//            .P, .E, .E]
//        nextMoveEvaluation(board, moveSet: [2], testcase: 1)
//        
//        // Winning game sequence.
//        board.board = [
//            .E, .P, .E,
//            .E, .C, .E,
//            .E, .E, .E]
//        nextMoveEvaluation(board, moveSet: [0, 2], testcase: 10)
//        board.board = [
//            .C, .P, .E,
//            .E, .C, .E,
//            .E, .E, .P]
//        nextMoveEvaluation(board, moveSet: [3, 6], testcase: 11)
//        board.board = [
//            .C, .P, .P,
//            .E, .C, .E,
//            .C, .E, .P]
//        nextMoveEvaluation(board, moveSet: [3], testcase: 12)
    }
    
    func nextMoveEvaluation(board: Board, moveSet: [Int], testcase: Int) {
        let engine = TTTEngine()
        // let bestMove = engine.findMaxMove(board)
        let bestMove = engine.findBestMove(board, player: .C)
        let result = find(moveSet, bestMove.move)
        println("TestBestMove/nextMoveEvalutation Testcase: \(testcase) Move: \(bestMove.move) Score: \(bestMove.score)")
        XCTAssertFalse(result == nil, "Fail testcase=\(testcase)")
        // XCTAssert(result != nil, "Pass")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
