//
//  Meme.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/10/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import Foundation
import UIKit

// Meme model object to store saved memes
struct Meme {
   let topCaption: String
   let bottomCaption: String
   let originalImage: UIImage
   let memedImage: UIImage
   
   init(topCaption: String, bottomCaption: String, originalImage: UIImage, memedImage: UIImage) {
      self.topCaption = topCaption
      self.bottomCaption = bottomCaption
      self.originalImage = originalImage
      self.memedImage = memedImage
   }
}
