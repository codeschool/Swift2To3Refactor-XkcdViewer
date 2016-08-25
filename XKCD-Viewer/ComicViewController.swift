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
    var comicImage: UIImage?
  
    // MARK: - View Controller Lifecycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        comicImageView.hidden = true
        comicTitleLabel.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = comic?.img {
            if let url = NSURL(string: image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    if let data = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.comicImage = UIImage(data: data)!
                            self.comicImageView.image = self.resizeImage(self.comicImage!, scaledToWidth: self.comicImageView.bounds.width)
                            self.resizeImageView(self.comicImageView)
                            self.repositionLabel(self.comicTitleLabel, relativeToImageView: self.comicImageView)
                            self.comicImageView.hidden = false
                            self.comicTitleLabel.hidden = false
                        }
                    }
                }
            }
        }

        comicTitleLabel.text = comic?.safe_title
        
        comicImageView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Sizing Helpers

    func resizeImage(sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        sourceImage.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeImageView(imageView: UIImageView) -> Void {
        var frame = imageView.frame
        frame.size.height = (imageView.image?.size.height)!
        imageView.frame = frame
    }
    
    func repositionLabel(label: UILabel, relativeToImageView: UIImageView) -> Void {
        var frame = label.frame
        frame.origin.y = CGRectGetMaxY(relativeToImageView.frame) + 20
        label.frame = frame
    }
    
    // MARK: - Actions

    @IBAction func showAltText(gesture: UIGestureRecognizer) -> Void {
        if gesture.state == .Began {
            let alertController = UIAlertController(title: comic?.safe_title, message: comic?.alt, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { _ in }))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}
