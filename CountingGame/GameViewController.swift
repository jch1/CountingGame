//
//  GameViewController.swift
//  CountingGame
//
//  Created by Jonathan Huang on 5/22/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
//                print("here i am")
                // Set the scale mode to scale to fit the window
//                print("asdfasdfasdf: \(scene.scaleMode)")
//                scene.scaleMode = .aspectFill
//                print("asdfasdfasdf: \(scene.scaleMode)")
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
