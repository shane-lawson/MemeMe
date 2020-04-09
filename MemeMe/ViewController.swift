//
//  ViewController.swift
//  MemeMe
//
//  Created by Shane Lawson on 4/9/20.
//  Copyright © 2020 Shane Lawson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

   @IBOutlet weak var topCaptionTextField: UITextField!
   @IBOutlet weak var bottomCaptionTextField: UITextField!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var cameraButton: UIBarButtonItem!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
   }

   override func viewWillAppear(_ animated: Bool) {
      cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
   }
   
   @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
      print("share button tapped")
   }
   
   @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
      topCaptionTextField.text = "TOP"
      bottomCaptionTextField.text = "BOTTOM"
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
}

