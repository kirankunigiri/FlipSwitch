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
    var getRandom: (() -> Int)!
    var lists: [[Int]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        self.view.backgroundColor = UIColor(red:0.149,  green:0.149,  blue:0.149, alpha:1)
        playAgainButton.layer.cornerRadius = playAgainButton.frame.height/2
        
        // Create a list of the switch numbers and remove the current number
        // to make sure that switches are only associated with another and not itself
        for index in 0...switches.count-1 {
            var list = [0, 1, 2, 3]
            list.remove(at: index)
            switches[index].tag = list[Int(arc4random_uniform(UInt32(3)))]
        }
        
        // Add tap gesture recognizers to each switch
        for button in switches {
            let tapgr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            button.addGestureRecognizer(tapgr)
        }
        
    }

    // Light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Handle taps on each switch
    func handleTap(recognizer: UITapGestureRecognizer) {
        
        // Don't do anything if it's still animating
        for button in switches {
            if button.animating {
                return
            }
        }
        
        // Flip the switch and the corresponding one
        let button = (recognizer.view as! SwitchView)
        button.flipSwitch()
        switches[button.tag].flipSwitch()
        
        // Check for game win
        var win = true
        for button in switches {
            if button.state {
                win = false
            }
        }
        
        // Win
        if win {
            
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




extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}


