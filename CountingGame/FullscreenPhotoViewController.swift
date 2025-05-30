//
//  FullscreenPhotoViewController.swift
//  CountingGame
//
//  Created by Aram Alejandro Zamora Lores on 30.05.25.
//


import UIKit

class FullscreenPhotoViewController: UIViewController {

    var image: UIImage?  // Inject the image from outside

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set background color to black for best effect
        view.backgroundColor = .black

        // Create and configure UIImageView
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(imageView)

        // Optional: tap to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreen))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissFullscreen() {
        dismiss(animated: true, completion: nil)
    }
}