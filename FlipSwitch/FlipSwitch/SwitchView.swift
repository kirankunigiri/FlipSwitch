//
//  SwitchView.swift
//  FlipSwitch
//
//  Created by Kiran Kunigiri on 4/13/17.
//  Copyright © 2017 Kiran. All rights reserved.
//

import UIKit

class SwitchView: UIView {
    
    var state = true
    var animating = false
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = K.green
        self.layer.borderColor = K.darkGreen.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 5
        
        label = UILabel()
        label.text = "ON"
        label.font = UIFont(name: "Avenir-Book", size: 40)
        label.textColor = UIColor.white
        label.frame = self.bounds
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    func flipSwitch() {
        // Don't do anything if already animating
        if animating {
            return
        }
        animating = true
        
        // If on, turn off
        if state {
            self.backgroundColor = K.red
            self.layer.borderColor = K.darkRed.cgColor
            self.label.text = "OFF"
            flipOffAnimation()
        } else { // If off, turn on
            self.backgroundColor = K.green
            self.layer.borderColor = K.darkGreen.cgColor
            self.label.text = "ON"
            flipOnAnimation()
        }
        state = !state
    }
    
    private func flipOffAnimation() {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromBottom, animations: {
        }, completion: { (completed) in
            self.animating = false
        })
    }
    
    private func flipOnAnimation() {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromTop, animations: {
        }, completion: { (completed) in
            self.animating = false
        })
    }
    
}
