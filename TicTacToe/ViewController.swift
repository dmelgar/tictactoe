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
    var busy = false

    override func viewDidLoad() {
        // Create view
        super.viewDidLoad()

        view.autoresizesSubviews = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        boardView = TTTBoardView()
        boardView.delegate = self
        boardView.backgroundColor = UIColor.white
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        
        info = UILabel()
        info.text = "Welcome to Tic Tac Toe. Try to beat the computer... if you dare"
        info.numberOfLines = 0
        info.setContentCompressionResistancePriority(100, for: UILayoutConstraintAxis.horizontal)
        info.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(info)
        
        restartButton = UIButton()
        restartButton.setTitle("New Game", for: UIControlState())
        restartButton.setTitleColor(UIColor.blue, for: UIControlState())
        restartButton.addTarget(self, action: #selector(ViewController.restart), for: .touchUpInside)
        
        // Swift bug, Xcode 6.3. Cannot use priority constant, needs to be value
        restartButton.setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.horizontal)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(restartButton)
    
        let viewsDictionary = ["info": info, "button": restartButton, "board": boardView] as [String : Any]
        let visualConstraints = [
            "H:|-(>=10)-[board]-(>=10)-|",
            "V:|-30-[button]-[board]-30-|",
            "H:|-[info]-(>=8)-[button]-|",
            "V:|-30-[info]-[board]-30-|"]

        let constraints = getVisualConstraintArray(vcArray: visualConstraints, options: [], metrics: nil, viewDictionary: viewsDictionary as [String : AnyObject])
        
        // Constrain board to be square
        let aspectRatio = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal, toItem: boardView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)
        boardView.addConstraint(aspectRatio)
        
        // Constrain board to be centered relative to parent view
        let constraint = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
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
    func getVisualConstraintArray(vcArray: [String], options opts: NSLayoutFormatOptions, metrics: [String: AnyObject]?,
        viewDictionary: [String: AnyObject]) -> [NSLayoutConstraint] {
            var result = [NSLayoutConstraint]()
            for visualConstraint in vcArray {
                let newConstraints = NSLayoutConstraint.constraints(withVisualFormat: visualConstraint,
                    options: opts, metrics: metrics, views: viewDictionary)
                result += newConstraints
            }
            return result
    }


    //MARK: Delegate method
    // Called by boardView when player has moved
    func playerMoved(_ playerMove: Int) {
        if isWon || busy {
            return
        }
        var status = board.move(playerMove, player: .p)
        if status != .invalid {
            boardView.board = board
            boardView.setNeedsDisplay()
        }
        switch status {
        case Board.BoardState.cWon:
            info.text = "Computer Won"
        case .pWon:
            info.text = "You Won! Wait... thats not supposed to be able to happen"
        case .draw:
            info.text = "Draw"
        case .invalid:
            info.text = "Space is occupied"
        case .valid:
            // Figure out computer's move
            // Update the view
            self.busy = true
            DispatchQueue.global(qos:.background).async {
                let computerMove = self.engine.findBestMove(self.board, player: .c).move
                DispatchQueue.main.async {
                    self.busy = false
                    status = self.board.move(computerMove, player: .c)
                    switch status {
                    case .draw:
                        self.info.text = "Draw"
                    case .cWon:
                        self.info.text = "Computer Won."
                        self.isWon = true
                    default:
                        self.info.text = "Your turn"
                    }
                    self.boardView.board = self.board
                    self.boardView.setNeedsDisplay()
                }
            }
        }
    }
}


