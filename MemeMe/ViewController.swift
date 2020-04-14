//
//  ViewController.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/9/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate, UIFontPickerViewControllerDelegate {

   @IBOutlet weak var topCaption: UITextField!
   @IBOutlet weak var bottomCaption: UITextField!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var cameraButton: UIBarButtonItem!
   @IBOutlet weak var shareButton: UIBarButtonItem!
   @IBOutlet var toolbars: [UIToolbar]!
   
   enum KeyboardNotificationType {
      case willShow
      case willHide
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configureMemeCaption(topCaption)
      configureMemeCaption(bottomCaption)
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
      shareButton.isEnabled = false
      imageView.contentMode = .scaleAspectFit
      subscribeToKeyboardNotification(of: .willShow)
      subscribeToKeyboardNotification(of: .willHide)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      unsubscribeFromKeyboardNotification(of: .willShow)
      unsubscribeFromKeyboardNotification(of: .willHide)
   }
   
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
      UIGraphicsBeginImageContext(view.frame.size)
      view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
      let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      toolbars.forEach {$0.isHidden = false}
      
      let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
      activityViewController.completionWithItemsHandler = { _, completed, _, _ in
         if completed {
            self.saveMeme(memedImage)
         }
      }
      present(activityViewController, animated: true, completion: nil)
   }
   
   @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
      topCaption.text = "TOP"
      bottomCaption.text = "BOTTOM"
      imageView.image = nil
      shareButton.isEnabled = false
   }
   
   @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
      present(createImagePickerControllerWith(source: .camera), animated: true, completion: nil)
   }
   
   @IBAction func albumButtonTapped(_ sender: UIBarButtonItem) {
      present(createImagePickerControllerWith(source: .photoLibrary), animated: true, completion: nil)
   }
   
   fileprivate func saveMeme(_ memedImage: UIImage) {
      _ = Meme(topCaption: topCaption.text!, bottomCaption: bottomCaption.text!, originalImage: imageView.image!, memedImage: memedImage)
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
         .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
      ]
      textField.adjustsFontSizeToFitWidth = true
      textField.minimumFontSize = 17.0
      textField.textAlignment = .center
   }
   
   fileprivate func subscribeToKeyboardNotification(of type: KeyboardNotificationType) {
      switch type {
      case .willShow:
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
      case .willHide:
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      }
   }
   
   fileprivate func unsubscribeFromKeyboardNotification(of type: KeyboardNotificationType) {
      switch type {
      case .willShow:
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
      case .willHide:
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
      }
   }
   
   @objc fileprivate func keyboardWillShow(_ notification: Notification) {
      if bottomCaption.isEditing {
         view.frame.origin.y -= getKeyboardHeight(notification)
      }
   }
   
   @objc fileprivate func keyboardWillHide(_ notification: Notification) {
      if bottomCaption.isEditing {
         view.frame.origin.y += getKeyboardHeight(notification)
      }
   }
   
   fileprivate func getKeyboardHeight(_ notification: Notification) -> CGFloat {
      let userInfo = notification.userInfo
      let keyboardRect = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
      return keyboardRect.height
   }
   
   // MARK: - UIImagePickerControllerDelegate
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[.originalImage] as? UIImage {
         imageView.image = image
         shareButton.isEnabled = true
      }
      dismiss(animated: true, completion: nil)
   }
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
   }
   
   // MARK: - UITextFieldDelegate
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      textField.text = ""
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
