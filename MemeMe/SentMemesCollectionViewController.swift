//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/19/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCollectionViewCell"

class SentMemesCollectionViewCell: UICollectionViewCell {
    
   @IBOutlet weak var imageView: UIImageView!
   
}

class SentMemesCollectionViewController: UICollectionViewController {

   var memes: [Meme] {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      return appDelegate.memes
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      collectionView.reloadData()
   }

   // MARK: - UICollectionViewDataSource

   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return memes.count
   }

   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let meme = memes[indexPath.item]
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
      if let myCell = cell as? SentMemesCollectionViewCell {
         myCell.imageView.image = meme.memedImage
         myCell.imageView.contentMode = .scaleAspectFill
         return myCell
      }
      return cell
   }

   // MARK: - UICollectionViewDelegate

   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let meme = memes[indexPath.item]
      let detailVC = storyboard?.instantiateViewController(withIdentifier: "memeDetailViewController") as! MemeDetailViewController
      detailVC.meme = meme
      show(detailVC, sender: self)
   }
}
