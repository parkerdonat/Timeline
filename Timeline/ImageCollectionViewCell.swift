//
//  ImageCollectionViewCell.swift
//  Timeline
//
//  Created by Parker Donat on 2/29/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func updateWithImageIdentifier(identifier: String) {
        
        ImageController.imageForIdentifier(identifier) { (image) -> Void in
            self.imageView.image = image
        }
    }
}
