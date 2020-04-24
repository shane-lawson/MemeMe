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
   
   override func viewDidLoad() {
      super.viewDidLoad()

      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false

      // Do any additional setup after loading the view.
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      collectionView.reloadData()
   }
   
   /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using [segue destinationViewController].
      // Pass the selected object to the new view controller.
   }
   */

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
   
   /*
   // Uncomment this method to specify if the specified item should be highlighted during tracking
   override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
      return true
   }
   */

   /*
   // Uncomment this method to specify if the specified item should be selected
   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
      return true
   }
   */

   /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
      return false
   }

   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
      return false
   }

   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

   }
   */

}
