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
         let fileURL = firstpath.URLByAppendingPathComponent(createFilename("jpg"), isDirectory: false)
         localPhotoURL = fileURL
         //Photo formatting
         let photo_fJPG = UIImageJPEGRepresentation(image, 0.5)
         //Write to file
         if let photoPath = fileURL.path {
            photo_fJPG.writeToFile(photoPath, atomically: true)
            //For testing
            println("Wrote picture to file \(photoPath)")
            upload(fileURL)
         }
      }
   }
   
   //iCloud upload functionality
   func upload(fileURL: NSURL) {
      //Checking for iCloud connection
      if let token = NSFileManager.defaultManager().ubiquityIdentityToken {
         println("iCloud connection is active with token \(token)")
      
         //Creating a new thread for getting the iCloud URL to keep the app efficient
         dispatch_async(dispatch_queue_create("com.asuna.LiveTrace.cloud", nil), {
            //FIle Manager
            let files = NSFileManager.defaultManager()
            
            //Get URL of the iCLoud drive
            if let cloudURL = files.URLForUbiquityContainerIdentifier("iCloud.com.asuna.LiveTrace"){
               //Update URL by appending '/Documents'
               var cloudURLWithDocuments = cloudURL.URLByAppendingPathComponent("Documents", isDirectory: true)
               if !files.fileExistsAtPath(cloudURLWithDocuments.path!) {
                  var error: NSError?
                  files.createDirectoryAtURL(cloudURLWithDocuments, withIntermediateDirectories: false, attributes: nil, error: &error)
                  if let theError = error {
                     println("ERROR: Could not create Documents directory in iCloud for LiveTrace: \(theError.localizedDescription)")
                  }
               }
               //upload to iCloud
               dispatch_async(dispatch_get_main_queue(), {
                  //Going to call "setUbiquitous" on the file - this will upload it to iCloud
                  var error : NSError?
                  if let pathComponents = fileURL.pathComponents {
                     let pathComponentCount = pathComponents.count
                     let filename: String = pathComponents[pathComponentCount - 1] as String
                     println("Filename part is \(filename)")
                     
                     //destinationURL will need to include the filename (path with filename)
                     var destinationURL = cloudURLWithDocuments.URLByAppendingPathComponent(filename, isDirectory: false)
                     
                     //Telling the environment to upload to cloud
                     //Environment will take care of when to upload - may not be instantaneous
                     println("Set the ubiquitous flag for \(fileURL). Will deploy to cloud as soon as possible (at \(cloudURL)).")
                     
                     //If upload was successful, print success to console.
                     if files.setUbiquitous(true, itemAtURL: fileURL, destinationURL: destinationURL, error: &error) {
                        println("Uploaded successfully!")
                        //Else :(
                     } else {
                        if let theError = error {
                           println("Upload Failed. ERROR: \(theError.localizedDescription)")
                     
                        }
                     }
                  }
               })
            } else {
                  println("ERROR: Failed to get ubiquity URL")
            }
         })
      } else {
         println("ERROR: iCloud is unavaliable.")
      }
   }
   
   func createFilename(ext: String) -> String {
      let timestamp = NSDate().timeIntervalSince1970
      return "File\(timestamp).\(ext)"
   }
}