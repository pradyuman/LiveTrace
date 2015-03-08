//
//  ViewController.swift
//  LiveTrace
//
//  Created by Pradyuman Vig on 3/6/15.
//  Copyright (c) 2015 Asuna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   @IBOutlet weak var myImageView: UIImageView!
   
   var takenImage: UIImage?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }
   
   //Open camera when button is pressed
   @IBAction func cameraButton(sender: AnyObject) {
      let imagePicker = UIImagePickerController()
      //If camera is available, open camera
      if UIImagePickerController.isSourceTypeAvailable(.Camera){
         imagePicker.sourceType = .Camera
      }
      //If camera is not available then open Photo Library
      else {
         imagePicker.sourceType = .PhotoLibrary
      }
      
      //Self delegate
      imagePicker.delegate = self
      
      //Present the camera app
      presentViewController(imagePicker, animated: true, completion: nil)
   }
   
   //Takes the image from the camera -> displays it on the phone and uploads it to iCloud
   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      //pickedPhoto is the photo taken
      let pickedPhoto = info[UIImagePickerControllerOriginalImage] as UIImage
      
      takenImage = pickedPhoto
      
      //Dismiss Camera
      dismissViewControllerAnimated(true, completion: nil)
      
      if takenImage != nil {
         //Display image on the iPhone after it is taken
         myImageView.image = takenImage
         //Save image to iPhone
         saveToDisk(takenImage);
      }
      
   }
   
}

