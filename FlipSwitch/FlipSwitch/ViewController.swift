//
//  ViewController.swift
//  FlipSwitch
//
//  Created by Kiran Kunigiri on 4/13/17.
//  Copyright © 2017 Kiran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    var switches: [SwitchView] = []
    @IBOutlet var tutorialLabel: UILabel!
    @IBOutlet var winViews: [UIView]!
    @IBOutlet var winLabel: UILabel!
    @IBOutlet var playButtons: [UIButton]!
    @IBOutlet var containerView: UIView!
    var titleSwitch = SwitchView()
    
    // Sizing constraints
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    
    // Sizing variables
    var spacing: CGFloat = 50
    var size: CGFloat = 120
    var numSwitches = 4
    var gridSize: CGFloat {
        return CGFloat(numSwitches).squareRoot()
    }
    var playing = false
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !playing {
            titleSwitch.frame = containerView.bounds
            return
        }
        
        // Resize switches
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        size = containerView.frame.width/CGFloat(gridSize*1.25)
        spacing = (containerView.frame.width - gridSize*size)/(gridSize-1)
        
        for index in 0...switches.count-1 {
            let button = switches[index]
            button.frame = CGRect(x: x, y: y, width: size, height: size)
            if index != 0 && (index+1) % Int(gridSize) == 0 {
                x = 0
                y += size + spacing
            } else {
                x += size + spacing
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        self.view.backgroundColor = K.darkGray
        
        // Button setup
        for button in playButtons {
            button.layer.cornerRadius = button.frame.height/2
            button.backgroundColor = K.blue
            
            // Add shadow to button
            button.layer.shadowColor = K.blueShadow.cgColor
            button.layer.shadowOpacity = 1
            button.layer.shadowOffset = CGSize.zero
            button.layer.shadowRadius = 6
        }
        
        // Adjust constraints for small screen
        if self.view.frame.height < 600 {
            tutorialLabel.font = UIFont(name: tutorialLabel.font.fontName, size: 18)
        }
        if self.view.frame.height > 700 {
            leadingConstraint.constant = 30
            trailingConstraint.constant = 30
        }
        
        // Setup beginning mode
        tutorialLabel.alpha = 0
        winLabel.text = K.beginningText
        containerView.addSubview(titleSwitch)
        titleSwitch.label.text = "PLAY"
//        titleSwitch.layer.cornerRadius = 10
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
        for tag in button.tags {
            switches[tag].flipSwitch()
        }
        
        // Check for game win
        var win = true
        for button in switches {
            if button.state {
                win = false
            }
        }
        
        // Win - Show the win views
        if win {
            showWinViews()
            winLabel.text = K.winText
        }
    }
    
    // Animates in the win views
    func showWinViews() {
        UIView.animate(withDuration: 0.5, animations: {
            self.tutorialLabel.alpha = 0
            for view in self.winViews {
                view.alpha = 1
            }
        })
    }
    
    func showTutorialView() {
        UIView.animate(withDuration: 0.5) {
            self.tutorialLabel.alpha = 1
            for view in self.winViews {
                view.alpha = 0
            }
        }
    }
    
    
    @IBAction func easyButtonTapped(_ sender: UIButton) {
        numSwitches = 4
        changeGameMode()
    }
    
    @IBAction func mediumButtonTapped(_ sender: UIButton) {
        numSwitches = 9
        changeGameMode()
    }
    
    @IBAction func hardButtonTapped(_ sender: UIButton) {
        numSwitches = 16
        changeGameMode()
    }
    

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        if !playing {
            return
        }
        titleSwitch.alpha = 1
        playing = false
        removeSwitches()
        showWinViews()
        winLabel.text = K.beginningText
        UIView.transition(with: containerView, duration: 0.5, options: .transitionFlipFromBottom, animations: {
        }, completion: nil)
    }
    
    
    func changeGameMode() {
        resetGame()
        playing = true
        showTutorialView()
        viewDidLayoutSubviews()
        UIView.transition(with: containerView, duration: 0.5, options: .transitionFlipFromBottom, animations: {
        }, completion: nil)
    }
    
    func removeSwitches() {
        for button in switches {
            button.removeFromSuperview()
        }
        switches.removeAll()
    }
    
    func resetGame() {
        
        titleSwitch.alpha = 0
        
        removeSwitches()
        
        // Create switches
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for index in 0...numSwitches-1 {
            let button = SwitchView(frame: CGRect(x: x, y: y, width: size, height: size))
            self.containerView.addSubview(button)
            switches.append(button)
            if index % 2 == 0 {
                x += size + spacing
            } else {
                x = 0
                y += size + spacing
            }
        }
        
        // Add tap gesture recognizers to each switch
        for button in switches {
            let tapgr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            button.addGestureRecognizer(tapgr)
        }
        
        refreshButtonAssociations()
        
        // Unflip all the switches
        for button in switches {
            if !button.state {
                button.flipSwitch()
            }
        }
    }
    
    // Assigns each switch a corresponding switch that will also flip when tapped
    // Creates a list of the possible indexes and removes the current switch index
    // to make sure that switches are only associated with another and not itself
    func refreshButtonAssociations() {
        for index in 0...switches.count-1 {
            var list: [Int] = []
            for index in 0...numSwitches-1 {
                list.append(index)
            }
            list.remove(at: index)
            for i in 0...Int(gridSize)-2 {
                let random = Int(arc4random_uniform(UInt32(list.count)))
                switches[index].tags.append(list[random])
                list.remove(at: random)
            }
        }
    }

}


