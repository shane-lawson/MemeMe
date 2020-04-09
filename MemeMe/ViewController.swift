//
//  ViewController.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/9/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {

   @IBOutlet weak var topCaption: UITextField!
   @IBOutlet weak var bottomCaption: UITextField!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var cameraButton: UIBarButtonItem!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configureMemeCaption(topCaption)
      configureMemeCaption(bottomCaption)
   }

   override func viewWillAppear(_ animated: Bool) {
      cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
   }
   
   @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
      print("share button tapped")
   }
   
   @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
      topCaption.text = "TOP"
      bottomCaption.text = "BOTTOM"
      imageView.image = nil
   }
   
   @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
      present(createImagePickerControllerWith(source: .camera), animated: true, completion: nil)
   }
   
   @IBAction func albumButtonTapped(_ sender: UIBarButtonItem) {
      present(createImagePickerControllerWith(source: .photoLibrary), animated: true, completion: nil)
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
      textField.textAlignment = .center
   }
   
   // MARK: - UIImagePickerControllerDelegate
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[.originalImage] as? UIImage {
         imageView.image = image
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
}

