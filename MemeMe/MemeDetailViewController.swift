//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/23/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UITextFieldDelegate {
   
   var imageViewConstraints = [NSLayoutConstraint]()
   
   @IBOutlet weak var memeView: UIView!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var topCaption: UITextField!
   @IBOutlet weak var bottomCaption: UITextField!
   
   var meme: Meme!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      memeView.layer.borderWidth = 2.0
      memeView.layer.borderColor = UIColor.orange.cgColor
      imageView.layer.borderWidth = 1.0
      imageView.layer.borderColor = UIColor.green.cgColor
      
      imageView.image = meme.originalImage
      topCaption.text = meme.topCaption
      bottomCaption.text = meme.bottomCaption
      
      configureMemeCaption(topCaption)
      configureMemeCaption(bottomCaption)

      setConstraints()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      switch segue.identifier {
      case "detailToEdit":
         let editVC = segue.destination as! EditMemeViewController
         editVC.meme = meme
      default:
         break
      }
   }
   
   @objc fileprivate func orientationDidChange(_ notificaiton: Notification) {
      updateImageConstraints()
   }
   
   fileprivate func configureMemeCaption(_ textField: UITextField) {
      textField.delegate = self
      textField.defaultTextAttributes = [
         .strokeColor: UIColor.black,
         .foregroundColor: UIColor.white,
         .strokeWidth: -5.0,
         .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
      ]
      textField.adjustsFontSizeToFitWidth = true
      textField.minimumFontSize = 17.0
      textField.textAlignment = .center
      // set constraint so caption height is always the intrinsic content size
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.heightAnchor.constraint(equalToConstant: textField.intrinsicContentSize.height).isActive = true
   }
   
   fileprivate func setConstraints() {
      imageView.translatesAutoresizingMaskIntoConstraints = false
      // add image view to meme view and set constraints relative to meme view
      memeView.addSubview(imageView)
      updateImageConstraints()
      // add top caption to meme view and set constraints relative to image view
      memeView.addSubview(topCaption)
      topCaption.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20).isActive = true
      topCaption.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20).isActive = true
      imageView.trailingAnchor.constraint(equalTo: topCaption.trailingAnchor, constant: 20).isActive = true
      // add bottom caption to meme view and set constraints relative to image view
      memeView.addSubview(bottomCaption)
      imageView.bottomAnchor.constraint(equalTo: bottomCaption.bottomAnchor, constant: 20).isActive = true
      bottomCaption.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20).isActive = true
      imageView.trailingAnchor.constraint(equalTo: bottomCaption.trailingAnchor, constant: 20).isActive = true
   }
   
   fileprivate func updateImageConstraints() {
      func getImageRect(rect: CGRect, image: UIImage) -> CGRect {
         let widthFactor = rect.width / image.size.width
         let heightFactor = rect.height / image.size.height
         let minFactor = min(widthFactor, heightFactor)
         
         let size = CGSize(width: minFactor * image.size.width, height: minFactor * image.size.height)
         let origin = CGPoint(x: (rect.width - size.width) / 2 , y: (rect.height - size.height) / 2)
         return CGRect(origin: origin, size: size)
      }
      
      imageViewConstraints.forEach { $0.isActive = false }
      imageViewConstraints.removeAll()
      if let image = imageView.image {
         let imageRect = getImageRect(rect: memeView.frame, image: image)
         if imageRect.origin.x <= imageRect.origin.y {
            // for images that are wider than the view, pin the top and bottom to the scaled image rect, and leading and trailing to "parent" edges
            imageViewConstraints.append(imageView.topAnchor.constraint(equalTo: memeView.topAnchor, constant: imageRect.origin.y))
            imageViewConstraints.append(memeView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: imageRect.origin.y))
            imageViewConstraints.append(imageView.leadingAnchor.constraint(equalTo: memeView.leadingAnchor, constant: 0))
            imageViewConstraints.append(memeView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0))
         } else {
            // for images that are narrower than the view, pin the top and bottom to "parent" edges, and leading and trailing to the scaled image rect
            imageViewConstraints.append(imageView.topAnchor.constraint(equalTo: memeView.topAnchor, constant: 0))
            imageViewConstraints.append(memeView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0))
            imageViewConstraints.append(imageView.leadingAnchor.constraint(equalTo: memeView.leadingAnchor, constant: imageRect.origin.x))
            imageViewConstraints.append(memeView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: imageRect.origin.x))
         }
      } else {
         // when the constraints are initially set, pin them all to the "parent" edges
         imageViewConstraints.append(imageView.topAnchor.constraint(equalTo: memeView.topAnchor, constant: 0))
         imageViewConstraints.append(memeView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0))
         imageViewConstraints.append(imageView.leadingAnchor.constraint(equalTo: memeView.leadingAnchor, constant: 0))
         imageViewConstraints.append(memeView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0))
      }
      imageViewConstraints.forEach { $0.isActive = true }
   }
   
   // MARK: - UITextFieldDelegate
   
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      return false
   }
}
