//
//  ViewController.swift
//  Exercise1
//
//  Created by Ramanpreet Singh on 2020-01-08.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var squareLabel: UILabel!
    
    var topToBottomTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        initTopToBottomTimer()
    }
    
    private func initGestures() {
        // Left swipe gesture
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureRecognition))
        leftGesture.direction = .left
        // Right swipe gesture
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureRecognition))
        leftGesture.direction = .right
        squareLabel.addGestureRecognizer(leftGesture)
        squareLabel.addGestureRecognizer(rightGesture)
    }
     
    @objc private func gestureRecognition(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left: break
        case .right: break
        default: break
        }
    }
    
    private func initTopToBottomTimer() {
        topToBottomTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(topToBottomAnimation), userInfo: nil, repeats: true)
    }
    
    @objc private func topToBottomAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let `self` = self else { return }
            if self.squareLabel.frame.maxY < self.view.frame.size.height {
                if self.view.frame.size.height - self.squareLabel.frame.maxY >= 150 {
                    self.squareLabel.frame.origin.y += 150
                } else {
                    self.squareLabel.frame.origin.y += self.view.frame.size.height - self.squareLabel.frame.maxY
                }
            } else {
                self.topToBottomTimer?.invalidate()
            }
        }
    }
}

