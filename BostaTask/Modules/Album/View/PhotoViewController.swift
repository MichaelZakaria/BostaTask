//
//  PhotoViewController.swift
//  BostaTask
//
//  Created by Marco on 2024-11-19.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    var image: UIImage?
    var imageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = imageTitle

        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(scrollView)
        
        let image = image
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        scrollView.contentSize = imageView.bounds.size
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
