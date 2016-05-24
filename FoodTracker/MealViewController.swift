//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Michael Riegelhaupt on 4/29/16.
//  Copyright © 2016 Riegelhaupt. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    let spinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    static let GOOGLE_API_KEY = "AIzaSyDPKOELmAJNrZwNCgCHL3ZR8AbxkUz25VY"
    static let customSearchEngineUrl = "https://www.googleapis.com/customsearch/v1?key=AIzaSyDPKOELmAJNrZwNCgCHL3ZR8AbxkUz25VY&q=%@"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        
        if let initialMeal = meal {
            navigationItem.title = initialMeal.name
            nameTextField.text = initialMeal.name
            ratingControl.rating = initialMeal.rating
            photoImageView.image = initialMeal.photo
        }
        photoImageView.addSubview(spinner)
        spinner.frame = photoImageView.bounds
        spinner.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        spinner.center = photoImageView.center
        checkValidMealName()
    }
    
    //    MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.sourceType = .PhotoLibrary
//        imagePickerController.delegate = self
//        presentViewController(imagePickerController, animated: true, completion: nil)
        feelingLuckyImage()
    }
    
    typealias UrlResponse = (data:NSData?, response: NSURLResponse?, error:NSError?)
    
    func feelingLuckyImage() {
        guard let searchTerm = nameTextField.text else { return }
        let searchString = String(format: MealViewController.customSearchEngineUrl, searchTerm)
        if let checkedURL = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/8/88/Bright_red_tomato_and_cross_section02.jpg") {
            self.spinner.startAnimating()
            self.photoImageView.userInteractionEnabled = false;
            getDataFromUrl(checkedURL) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    self.photoImageView.image = UIImage(data: data)
                    self.spinner.stopAnimating()
                    self.photoImageView.userInteractionEnabled = true;
                }
            }
        }
    }
    
    func getDataFromUrl(url: NSURL, completion: (UrlResponse -> Void)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: completion).resume()
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating;
            
            meal = Meal(name: name, photo: photo, rating: rating)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
        
    }
    
    func checkValidMealName() {
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

