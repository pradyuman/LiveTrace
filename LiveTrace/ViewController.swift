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

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   @IBAction func cameraButton(sender: AnyObject) {
      let imagePicker = UIImagePickerController()
      if UIImagePickerController.isSourceTypeAvailable(.Camera){
         imagePicker.sourceType = .Camera
      }
      else{
         imagePicker.sourceType = .PhotoLibrary
      }
      
      //Self delegate
      imagePicker.delegate = self
      
      presentViewController(imagePicker, animated: true, completion: nil)
   }
   
   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      let pickedPhoto = info[UIImagePickerControllerOriginalImage] as UIImage
      
      takenImage = pickedPhoto
      
      dismissViewControllerAnimated(true, completion: nil)
      
      if takenImage != nil {
         myImageView.image = takenImage
      
      }
      
   }
   
}

