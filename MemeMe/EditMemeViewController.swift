//
//  EditMemeViewController.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/9/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate, UIFontPickerViewControllerDelegate {
   
   enum NotificationType {
      case keyboardWillShow
      case keyboardWillHide
      case orientationDidChange
      
      var notification: NSNotification.Name {
         switch self {
         case .keyboardWillShow:
            return UIResponder.keyboardWillShowNotification
         case .keyboardWillHide:
            return UIResponder.keyboardWillHideNotification
         case .orientationDidChange:
            return UIDevice.orientationDidChangeNotification
         }
      }
      
      var selector: Selector {
         switch self {
         case .keyboardWillShow:
            return #selector(keyboardWillShow(_:))
         case .keyboardWillHide:
            return #selector(keyboardWillHide(_:))
         case .orientationDidChange:
            return #selector(orientationDidChange(_:))
         }
      }
   }
   
   // MARK: - Properites
   
   var imageViewConstraints = [NSLayoutConstraint]()
   var meme: Meme?
   var appDelegate: AppDelegate {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      return appDelegate
   }
   
   // MARK: - IBOutlets
   
   @IBOutlet weak var topCaption: UITextField!
   @IBOutlet weak var bottomCaption: UITextField!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var memeView: UIView!
   @IBOutlet weak var cameraButton: UIBarButtonItem!
   @IBOutlet weak var shareButton: UIBarButtonItem!
   @IBOutlet var toolbars: [UIToolbar]!

   
   // MARK: - Overrides
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let meme = meme {
         imageView.image = meme.originalImage
         topCaption.text = meme.topCaption
         bottomCaption.text = meme.bottomCaption
      }
      
      configureMemeCaption(topCaption)
      configureMemeCaption(bottomCaption)
      
      setConstraints()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
      shareButton.isEnabled = imageView.image != nil
      imageView.contentMode = .scaleAspectFit
      subscribeToNotification(of: .keyboardWillShow)
      subscribeToNotification(of: .keyboardWillHide)
      subscribeToNotification(of: .orientationDidChange)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      unsubscribeFromNotification(of: .keyboardWillShow)
      unsubscribeFromNotification(of: .keyboardWillHide)
      unsubscribeFromNotification(of: .orientationDidChange)
   }
   
   //MARK: - IBActions
   
   @IBAction func decreaseFontSize(_ sender: UIBarButtonItem) {
      if let font = topCaption.font {
         topCaption.font = font.withSize(font.pointSize - 5.0)
         bottomCaption.font = font.withSize(font.pointSize - 5.0)
      }
   }
   
   @IBAction func increaseFontSize(_ sender: UIBarButtonItem) {
      if let font = topCaption.font {
         topCaption.font = font.withSize(font.pointSize + 5.0)
         bottomCaption.font = font.withSize(font.pointSize + 5.0)
      }
   }
   
   @IBAction func fontButtonTapped(_ sender: UIBarButtonItem) {
      let fontPicker = UIFontPickerViewController()
      fontPicker.delegate = self
      present(fontPicker, animated: true, completion: nil)
   }
   
   @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
      toolbars.forEach {$0.isHidden = true}
      // create memedImage by capturing view hierachy drawn in image context
      UIGraphicsBeginImageContext(CGSize(width: view.frame.size.width, height: view.frame.size.height-view.safeAreaInsets.bottom))
      view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
      let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      toolbars.forEach {$0.isHidden = false}
      
      // create Activity View Controller and save memedImage upon completion
      let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
      activityViewController.completionWithItemsHandler = { [unowned self] _, completed, _, _ in
         if completed {
            self.saveMeme(memedImage)
         }
      }
      present(activityViewController, animated: true, completion: nil)
   }
   
   @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
      dismiss(animated: true, completion: nil)
   }
   
   @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
      present(createImagePickerControllerWith(source: .camera), animated: true, completion: nil)
   }
   
   @IBAction func albumButtonTapped(_ sender: UIBarButtonItem) {
      present(createImagePickerControllerWith(source: .photoLibrary), animated: true, completion: nil)
   }
   
   // MARK: - Helper funcs
   
   fileprivate func saveMeme(_ memedImage: UIImage) {
      appDelegate.memes.append(Meme(topCaption: topCaption.text!, bottomCaption: bottomCaption.text!, originalImage: imageView.image!, memedImage: memedImage, font: topCaption.font!))
      toolbars.first?.items?.last?.title = "Done"
   }
   
   fileprivate func createImagePickerControllerWith(source: UIImagePickerController.SourceType) -> UIImagePickerController {
      let imagePickerController = UIImagePickerController()
      imagePickerController.sourceType = source
      imagePickerController.delegate = self
      return imagePickerController
   }
   
   fileprivate func configureMemeCaption(_ textField: UITextField) {
      textField.delegate = self
      textField.defaultTextAttributes = [
         .strokeColor: UIColor.black,
         .foregroundColor: UIColor.white,
         .strokeWidth: -5.0,
         .font: meme != nil ? meme!.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
      ]
      textField.adjustsFontSizeToFitWidth = true
      textField.minimumFontSize = 17.0
      textField.textAlignment = .center
      // set constraint so caption height is always the intrinsic content size
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.heightAnchor.constraint(equalToConstant: textField.intrinsicContentSize.height).isActive = true
   }
   
   fileprivate func subscribeToNotification(of type: NotificationType) {
      NotificationCenter.default.addObserver(self, selector: type.selector, name: type.notification, object: nil)
   }
   
   fileprivate func unsubscribeFromNotification(of type: NotificationType) {
      NotificationCenter.default.removeObserver(self, name: type.notification, object: nil)
   }
   
   @objc fileprivate func keyboardWillShow(_ notification: Notification) {
      func getKeyboardHeight(_ notification: Notification) -> CGFloat {
         let userInfo = notification.userInfo
         let keyboardRect = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
         return keyboardRect.height
      }
      
      if bottomCaption.isEditing {
         view.frame.origin.y -= getKeyboardHeight(notification)
      }
   }
   
   @objc fileprivate func keyboardWillHide(_ notification: Notification) {
      if bottomCaption.isEditing {
         view.frame.origin.y = 0
      }
   }

   @objc fileprivate func orientationDidChange(_ notification: Notification) {
      updateImageConstraints()
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
   
   // MARK: - UIImagePickerControllerDelegate
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[.originalImage] as? UIImage {
         imageView.image = image
         updateImageConstraints()
         shareButton.isEnabled = true
      }
      dismiss(animated: true, completion: nil)
   }
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
   }
   
   // MARK: - UITextFieldDelegate
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      if textField.text == "TOP" || textField.text == "BOTTOM" {
         textField.text = ""
      }
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   // MARK: - UIFontPickerViewControllerDelegate
   
   func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
      if let fontDescriptor = viewController.selectedFontDescriptor {
         let font = UIFont(descriptor: fontDescriptor, size: 40.0)
         topCaption.font = font
         bottomCaption.font = font
      }
   }
}
