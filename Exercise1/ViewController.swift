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
    let changePxPerSecond: CGFloat = 150
    
    enum MoveType {
        case topToBottom, bottomToTop, leftToRight, rightToLeft
    }
    
    var moveType: MoveType = .topToBottom
    var lastPosition: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        initTimer()
        initGestures()
    }
    
    private func initGestures() {
        // Left swipe gesture
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureRecognition))
        leftGesture.direction = .left
        // Right swipe gesture
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureRecognition))
        rightGesture.direction = .right
        view.addGestureRecognizer(leftGesture)
        view.addGestureRecognizer(rightGesture)
    }
     
    @objc private func gestureRecognition(gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            switch gesture.direction {
            case .left:
                moveType = .leftToRight
                lastPosition = squareLabel.frame.origin
                initTimer()
            case .right: break
            default: break
            }
        }
    }
    
    private func initTimer() {
        topToBottomTimer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func processTimer() {
        switch moveType {
        case .topToBottom:
            topToBottomAnimation()
        case .leftToRight:
            leftToRightAnimation()
        case .bottomToTop:
            bottomToTopAnimation()
        case .rightToLeft:
            rightToLeftAnimation()
        }
    }
    
    private func topToBottomAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let `self` = self else { return }
            let screenMaxY = self.view.frame.maxY - self.safeArea.bottom
            if self.squareLabel.frame.maxY < screenMaxY {
                if screenMaxY - self.squareLabel.frame.maxY >= self.changePxPerSecond {
                    self.squareLabel.frame.origin.y += self.changePxPerSecond
                } else {
                    self.squareLabel.frame.origin.y += screenMaxY - self.squareLabel.frame.maxY
                }
            } else {
                self.topToBottomTimer?.invalidate()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                    self.moveType = .leftToRight
                    self.initTimer()
                }
            }
        }
    }
    
    private func leftToRightAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let `self` = self else { return }
            let screenMaxX = self.view.frame.maxX
            if self.squareLabel.frame.maxX < screenMaxX {
                if screenMaxX - self.squareLabel.frame.maxX >= self.changePxPerSecond {
                    self.squareLabel.frame.origin.x += self.changePxPerSecond
                } else {
                    self.squareLabel.frame.origin.x += screenMaxX - self.squareLabel.frame.maxX
                }
            } else {
                self.topToBottomTimer?.invalidate()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                    self.moveType = .bottomToTop
                    self.initTimer()
                }
            }
        }
    }
    
    private func bottomToTopAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let `self` = self else { return }
            let screenMinY = self.view.frame.minY + self.safeArea.top
            if self.squareLabel.frame.minY > screenMinY {
                if self.squareLabel.frame.minY - screenMinY <= self.changePxPerSecond {
                    self.squareLabel.frame.origin.y -= self.changePxPerSecond
                } else {
                    self.squareLabel.frame.origin.y -= self.squareLabel.frame.minY - screenMinY
                }
            } else {
                self.topToBottomTimer?.invalidate()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                    self.moveType = .rightToLeft
                    self.initTimer()
                }
            }
        }
    }
    
    private func rightToLeftAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let `self` = self else { return }
            let screenMinX = self.view.frame.minX
            if self.squareLabel.frame.minX > screenMinX {
                if self.squareLabel.frame.minX - screenMinX >= self.changePxPerSecond {
                    self.squareLabel.frame.origin.x -= self.changePxPerSecond
                } else {
                    self.squareLabel.frame.origin.x -= self.squareLabel.frame.minX - screenMinX
                }
            } else {
                self.topToBottomTimer?.invalidate()
            }
        }
    }
    
    var safeArea: (top: CGFloat, bottom: CGFloat) {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            return (topPadding ?? 0, bottomPadding ?? 0)
        }
        return (0, 0)
    }
}

