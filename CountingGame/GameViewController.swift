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
    var fileNumber: Int = 0
    var files: [String] = []
    var imagesUrls: [String] = [
        "https://lh3.googleusercontent.com/pw/AP1GczOzYDYy68G9MHQJeEMix_nLVkTbezsqvp3_W-0Y_qws0q3P5JcCKuRUvVDAqEBGM8Syj18GTNt78ZRRPpKoWyz-vevBTShVb-I8xrhyYvdFt6wn6iqa=w1069-h802-no",
        "https://lh3.googleusercontent.com/pw/AP1GczOoU_pQTttD9NlciYuTXPu_6LLMQ8EZaLkuDmom_QliJACwd7pQwjdmO4bkPjFkej6Imk9AtQYuP_oHhBy9yNbQ-s1cm_XM-uKKWvvZauv6ElaU-yXoUgyuxxToYSLMrgvPLop7eaPbV8WMV8YTeKPf-Q=w1080-h810-s-no",
        "https://lh3.googleusercontent.com/pw/AP1GczMWSHYv4saC-HjUYSTzDc9uayqSCfDaUk5R-50QwqvuF0U4Pn36mESCE1KyKJZH8MyjfOYyhqfIkdf0_HIxI1J5jxSua892_nO51rhctlqYJ76GyM5xwRldC6BMX6eZbfnkBe8nQzv9SxQ1am1mttndcg=w540-h810-s-no"]

    override func viewDidLoad() {
        for url in imagesUrls {
            if let downloadURL = URL(string: url) {
                print(url)
                print(self.fileNumber)
                downloadFile(from: downloadURL, fileName: "file_\(self.fileNumber)") { fileURL, error in
                    if let error = error {
                        print("Download failed:", error)
                    } else if let fileURL = fileURL {
                        print("File saved to:", fileURL.path)
                        self.files.append(fileURL.path)
                    }
                }
                self.fileNumber += 1
            }
        }

        super.viewDidLoad()
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: view.bounds.size)
//                print("here i am")
                // Set the scale mode to scale to fit the window
//                print("asdfasdfasdf: \(scene.scaleMode)")
//                scene.scaleMode = .aspectFill
//                print("asdfasdfasdf: \(scene.scaleMode)")
                // Present the scene
            scene.scaleMode = .resizeFill
            scene.controller = self
            view.presentScene(scene)

            
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
    
    func presentPhotoFullScreen() {
        if fileNumber > 0 {
            let n = Int.random(in: 0..<fileNumber)
            if let image = UIImage(contentsOfFile: files[n]) {
                // Successfully loaded image
                print("Image loaded from tmp directory")
                let fullscreenVC = FullscreenPhotoViewController()
                fullscreenVC.image = image
                fullscreenVC.modalPresentationStyle = .fullScreen
                present(fullscreenVC, animated: true, completion: nil)
            } else {
                print("Failed to load image")
            }
        }
    }
}
