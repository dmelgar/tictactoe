//
//  ViewController.swift
//  TicTacToe
//
//  Created by David Melgar on 2/8/15.
//  Copyright (c) 2015 Broad Reach Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TTTBoardViewDelegate {
    var boardView: TTTBoardView = TTTBoardView()
    var engine: TTTEngine = TTTEngine()
    var board: Board = Board()
    var isWon = false
    var info: UILabel = UILabel()
    var restartButton: UIButton = UIButton()

    override func viewDidLoad() {
        // Create view
        super.viewDidLoad()

        view.autoresizesSubviews = true
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        boardView = TTTBoardView()
        boardView.delegate = self
        boardView.backgroundColor = UIColor.lightGrayColor()
        boardView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(boardView)
        
        info = UILabel()
        info.text = "Welcome to Tic Tac Toe. Try to beat the computer... if you dare"
        info.numberOfLines = 0
        info.setContentCompressionResistancePriority(100, forAxis: UILayoutConstraintAxis.Horizontal)
        info.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(info)
        
        restartButton = UIButton()
        restartButton.setTitle("New Game", forState: .Normal)
        restartButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        restartButton.addTarget(self, action: "restart", forControlEvents: .TouchUpInside)
        
        // Swift bug, Xcode 6.3. Cannot use priority constant, needs to be value
        restartButton.setContentCompressionResistancePriority(1000, forAxis: UILayoutConstraintAxis.Horizontal)
        restartButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(restartButton)
    
        let viewsDictionary = ["info": info, "button": restartButton, "board": boardView]
        let visualConstraints = [
            "H:|-(>=10)-[board]-(>=10)-|",
            "V:|-30-[button]-[board]-30-|",
            "H:|-[info]-(>=8)-[button]-|",
            "V:|-30-[info]-[board]-30-|"]

        let constraints = getVisualConstraintArray(vcArray: visualConstraints, options: nil, metrics: nil, viewDictionary: viewsDictionary)
        
        // Constrain board to be square
        let aspectRatio = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal, toItem: boardView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0)
        boardView.addConstraint(aspectRatio)
        
        // Constrain board to be centered relative to parent view
        var constraint = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(constraint)
        view.addConstraints(constraints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func restart() {
        board = Board()
        boardView.board = board
        boardView.setNeedsDisplay()
        info.text = "New game started"
        isWon = false
    }
    
    // Utility method: Add set array of visual constraints using same view and view dictionary
    func getVisualConstraintArray(#vcArray: [String], options opts: NSLayoutFormatOptions, metrics: [NSObject: AnyObject]?,
        viewDictionary: [NSObject: AnyObject]) -> [AnyObject] {
            var result = [AnyObject]()
            for visualConstraint in vcArray {
                let newConstraints = NSLayoutConstraint.constraintsWithVisualFormat(visualConstraint,
                    options: opts, metrics: metrics, views: viewDictionary)
                result += newConstraints
            }
            return result
    }


    //MARK: Delegate method
    // Called by boardView when player has moved
    func playerMoved(playerMove: Int) {
        if isWon {
            return
        }
        var status = board.move(playerMove, player: .P)
        if status != .Invalid {
            boardView.board = board
            boardView.setNeedsDisplay()
        }
        switch status {
        case Board.BoardState.CWon:
            info.text = "Computer Won"
        case .PWon:
            info.text = "You Won! Wait... thats not supposed to be able to happen"
        case .Draw:
            info.text = "Draw"
        case .Invalid:
            info.text = "Space is occupied"
        case .Valid:
            // Figure out computer's move
            // Update the view
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                let computerMove = engine.findBestMove(board, player: .C).move
                dispatch_async(dispatch_get_main_queue(), {
                    status = self.board.move(computerMove, player: .C)
                    switch status {
                    case .Draw:
                        self.info.text = "Draw"
                    case .CWon:
                        self.info.text = "Computer Won."
                        self.isWon = true
                    default:
                        self.info.text = "Your turn"
                    }
                    self.boardView.board = self.board
                    self.boardView.setNeedsDisplay()
                })
            })
        }
    }
}

