//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/19/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {
   
   @IBOutlet weak var label: UILabel!
   @IBOutlet weak var memeImageView: UIImageView!
   
}

class SentMemesTableViewController: UITableViewController {

   var memes: [Meme] {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      return appDelegate.memes
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      tableView.reloadData()
   }
   
   // MARK: - UITableViewDataSource

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return memes.count
   }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let meme = memes[indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell", for: indexPath)
      if let memeCell = cell as? SentMemesTableViewCell {
         memeCell.label.text = "\(meme.topCaption) \(meme.bottomCaption)"
         memeCell.memeImageView.image = meme.memedImage
         return memeCell
      }
      return cell
   }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let meme = memes[indexPath.row]
      let detailVC = storyboard?.instantiateViewController(withIdentifier: "memeDetailViewController") as! MemeDetailViewController
      detailVC.meme = meme
      show(detailVC, sender: self)
   }
}
