//
//  SwitchView.swift
//  FlipSwitch
//
//  Created by Kiran Kunigiri on 4/13/17.
//  Copyright © 2017 Kiran. All rights reserved.
//

import UIKit

class SwitchView: UIView {
    
    // Properties
    var state = true
    var animating = false
    var tags: [Int] = []
    private var animationDuration = 0.4
    
    // Views
    var label: UILabel!
    
    // Initializersz
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.font = UIFont(name: self.label.font.fontName, size: 0.33*self.frame.height)
    }
    
    func setupUI() {
        // View UI
        self.backgroundColor = K.green
        self.layer.cornerRadius = 5
        
        // Add text label
        label = UILabel()
        label.text = "ON"
        label.font = UIFont(name: "Avenir-Book", size: 40)
        label.textColor = UIColor.white
        label.frame = self.bounds
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(label)
        
        // Add shadow
        self.layer.shadowColor = K.greenShadow.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.layer.shadowRadius = 18
    }
    
    // Flips a switch's state
    func flipSwitch() {
        // Don't do anything if already animating
        if animating {
            return
        }
        animating = true
        
        // If on, turn off
        if state {
            flipOffAnimation()
        } else { // If off, turn on
            flipOnAnimation()
        }
        
        // Update state
        state = !state
    }
    
    // Button off animation
    private func flipOffAnimation() {
        self.backgroundColor = K.red
        self.layer.shadowColor = K.redShadow.cgColor
        self.label.text = "OFF"
        
        UIView.transition(with: self, duration: animationDuration, options: .transitionFlipFromBottom, animations: {
        }, completion: { (completed) in
            self.animating = false
        })
    }
    
    // Button on animation
    private func flipOnAnimation() {
        self.backgroundColor = K.green
        self.layer.shadowColor = K.greenShadow.cgColor
        self.label.text = "ON"
        
        UIView.transition(with: self, duration: animationDuration, options: .transitionFlipFromTop, animations: {
        }, completion: { (completed) in
            self.animating = false
        })
    }
    
}


