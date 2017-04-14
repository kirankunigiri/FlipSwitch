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
    @IBOutlet var tutorialLabel: UILabel!
    @IBOutlet var winViews: [UIView]!
    @IBOutlet var playAgainButton: UIButton!
    
    // Constraints for small screen
    @IBOutlet var hStackViews: [UIStackView]!
    @IBOutlet var vStackView: UIStackView!
    @IBOutlet var switchSize: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        self.view.backgroundColor = K.darkGray
        playAgainButton.layer.cornerRadius = playAgainButton.frame.height/2
        playAgainButton.backgroundColor = K.blue
        
        // Add shadow to button
        playAgainButton.layer.shadowColor = K.blueShadow.cgColor
        playAgainButton.layer.shadowOpacity = 1
        playAgainButton.layer.shadowOffset = CGSize.zero
        playAgainButton.layer.shadowRadius = 6
        
        // Hide win views
        for view in winViews {
            view.alpha = 0
        }
        
        // Adjust constraints for small screen
        if self.view.frame.height < 600 {
            for stackView in hStackViews {
                stackView.spacing = 20
            }
            vStackView.spacing = 20
            switchSize.constant = 100
            tutorialLabel.font = UIFont(name: tutorialLabel.font.fontName, size: 18)
            for button in switches {
                button.label.font = UIFont(name: button.label.font.fontName, size: 30)
            }
        }
        
        // Assign button associations
        refreshButtonAssociations()
        
        // Add tap gesture recognizers to each switch
        for button in switches {
            let tapgr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            button.addGestureRecognizer(tapgr)
        }
        
    }
    
    // Assigns each switch a corresponding switch that will also flip when tapped
    // Creates a list of the possible indexes and removes the current switch index
    // to make sure that switches are only associated with another and not itself
    func refreshButtonAssociations() {
        for index in 0...switches.count-1 {
            var list = [0, 1, 2, 3]
            list.remove(at: index)
            switches[index].tag = list[Int(arc4random_uniform(UInt32(3)))]
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
        
        // Win - Show the win views
        if win {
            UIView.animate(withDuration: 0.5, animations: { 
                self.tutorialLabel.alpha = 0
                for view in self.winViews {
                    view.alpha = 1
                }
            })
        }
    }
    
    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
        // Show the tutorial
        UIView.animate(withDuration: 0.5) { 
            self.tutorialLabel.alpha = 1
            for view in self.winViews {
                view.alpha = 0
            }
        }
        
        // Unflip all the switches
        for button in switches {
            if !button.state {
                button.flipSwitch()
            }
        }
        
        // Refresh the associations
        refreshButtonAssociations()
    }
    

}


