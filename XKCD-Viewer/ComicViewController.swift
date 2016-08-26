//
//  ComicViewController.swift
//  XKCD-Viewer
//
//  Created by Jon Friskics on 8/23/16.
//  Copyright © 2016 Code School. All rights reserved.
//

import UIKit

class ComicViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicTitleLabel: UILabel!
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    var comic: Comic?
  
    // MARK: - View Controller Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        comicImageView.isHidden = true
        comicTitleLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = comic?.img {
            if let url = URL(string: image) {
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.comicImageView.image = self.resizeImage(UIImage(data: data)!, scaledToWidth: self.comicImageView.bounds.width)
                            self.resizeImageView(self.comicImageView)
                            self.repositionLabel(self.comicTitleLabel, relativeToImageView: self.comicImageView)
                            self.comicImageView.isHidden = false
                            self.comicTitleLabel.isHidden = false
                        }
                    }
                }
            }
        }

        comicTitleLabel.text = comic?.safe_title
        
        comicImageView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Sizing Helpers

    func resizeImage(_ sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func resizeImageView(_ imageView: UIImageView) -> Void {
        var frame = imageView.frame
        frame.size.height = (imageView.image?.size.height)!
        imageView.frame = frame
    }
    
    func repositionLabel(_ label: UILabel, relativeToImageView: UIImageView) -> Void {
        var frame = label.frame
        frame.origin.y = relativeToImageView.frame.maxY + 20
        label.frame = frame
    }
    
    // MARK: - Actions

    @IBAction func showAltText(_ gesture: UIGestureRecognizer) -> Void {
        if gesture.state == .began {
            let alertController = UIAlertController(title: comic?.safe_title, message: comic?.alt, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in }))
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
