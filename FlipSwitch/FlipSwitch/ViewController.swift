//
//  ViewController.swift
//  FlipSwitch
//
//  Created by Kiran Kunigiri on 4/13/17.
//  Copyright © 2017 Kiran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outletrs
    @IBOutlet var switches: [SwitchView]!
    @IBOutlet var playAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.149,  green:0.149,  blue:0.149, alpha:1)
        playAgainButton.layer.cornerRadius = playAgainButton.frame.height/2
        
        var availableSwitches = switches
        for index in 0...switches.count-1 {
            switches[index].tag = index
        }
        
        for button in switches {
            let tapgr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            button.addGestureRecognizer(tapgr)
        }
        
//        var pairs = switches
//        pairs?.remove(at: 0)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let button = (recognizer.view as! SwitchView)
        button.flipSwitch()
        if button.tag == 0 {
            switches[1].flipSwitch()
        }
        if button.tag == 1 {
            switches[2].flipSwitch()
        }
        if button.tag == 2 {
            switches[3].flipSwitch()
        }
        if button.tag == 3 {
            switches[0].flipSwitch()
        }
    }

}

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

