//
//  TestData.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/19/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import Foundation
import UIKit

struct TestData {
   var memes = [Meme]()
   
   init() {
      for i in 1...5 {
         let newMeme = Meme(topCaption: "THING \(i)", bottomCaption: "OTHER THING \(i)", originalImage: UIImage(named: "test_image_\(i)")!, memedImage: UIImage(named: "test_meme_\(i)")!)
         memes.append(newMeme)
      }
   }
}
