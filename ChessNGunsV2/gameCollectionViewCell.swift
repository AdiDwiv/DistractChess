//
//  gameCollectionViewCell.swift
//  ChessNGunsV2
//
//  Created by Aditya Dwivedi on 11/24/16.
//  Copyright © 2016 org.cuappdev.project. All rights reserved.
//

import UIKit

class gameCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var imageViewBackground: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func hasImage() -> Bool {
        if imageView != nil {
            return true
        }
        return false
    }
    
    func hasBack() -> Bool {
        if imageViewBackground != nil {
            return true
        }
        return false
    }
    
    func setImage(image: UIImage) {
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width*0.65, height: contentView.frame.height*0.65)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.center = contentView.center
        contentView.addSubview(imageView)
    }
    
    func removeImage() {
        imageView.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackground(image: UIImage) {
        imageViewBackground = UIImageView(frame: contentView.frame)
        imageViewBackground.image = image
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        imageViewBackground.center = contentView.center
        imageViewBackground.backgroundColor = UIColor.white.withAlphaComponent(0)
        contentView.addSubview(imageViewBackground)
        contentView.sendSubview(toBack: imageViewBackground)
    }
    
    func removeBackground() {
        imageViewBackground.removeFromSuperview()
    }
    
}
