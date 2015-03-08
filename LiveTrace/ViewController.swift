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
   
   //Local photo URL
   var localPhotoURL: NSURL?
   //Image that the user takes
   var takenImage: UIImage?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }
   
   //Status update for testing
   func updateStatus(message: String) {
         println(message)
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
      
      if let theImage = takenImage {
         //Display image on the iPhone after it is taken
         myImageView.image = takenImage
         //Save image to iPhone
         saveToDisk(theImage);
      }
      
   }
   
   //Saves the image to the user's disk (preparing for upload)
   func saveToDisk(image: UIImage){
      //Getting user files from environment
      let userFiles = NSFileManager.defaultManager()
      //Getting URLs for the files in user's iCloud document folder
      let documentURLs = userFiles.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
      //Getting valid path to save image
      if let firstpath = documentURLs.first{
         let fileURL = firstpath.URLByAppendingPathComponent("image.jpg", isDirectory: false)
         localPhotoURL = fileURL
         //Photo formatting
         let photo_fJPG = UIImageJPEGRepresentation(image, 1.0)
         //Write to file
         if let photoPath = fileURL.path {
            photo_fJPG.writeToFile(photoPath, atomically: true)
            //For testing
            updateStatus("Wrote picture to file \(photoPath)")
         }
      }
   }
   
   //iCloud upload functionality
   func upload(sender: AnyObject) {
      if let imageURL = localPhotoURL {
         //Creating a new thread for getting the iCloud URL to keep the app efficient
         dispatch_async(dispatch_queue_create("com.asuna.LiveTrace.cloud", nil), {
            let files = NSFileManager.defaultManager()
            let cloudURL = files.URLForUbiquityContainerIdentifier("iCloud.com.asuna.LiveTrace")
            dispatch_async(dispatch_get_main_queue(), {
               self.updateStatus("Got iCloud URL: \(cloudURL)")
               self.uploadFileToCloud(imageURL, cloudURL: cloudURL!)
            })
         })
      }
      else {
         updateStatus("ERROR:No local file to upload.")
      }
   }
   
   //Tell environment to upload to iCloud
   func uploadFileToCloud(localURL: NSURL, cloudURL: NSURL) {
      let files = NSFileManager.defaultManager()
      
      var error : NSError?
      
      //Telling the environment to upload to cloud
      //Environment will take care of when to upload - may not be instantaneous
      files.setUbiquitous(true, itemAtURL: localURL, destinationURL: cloudURL, error: &error)
      updateStatus("Set the ubiquitous flag for \(localURL). Will deploy to cloud as soon as possible (at \(cloudURL)).")
   }
}

