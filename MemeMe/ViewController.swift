//
//  ViewController.swift
//  MemeMe
//
//  Created by India Doria on 6/29/20.
//  Copyright © 2020 India Doria. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    //MARK: -Outlets
    
    @IBOutlet var memeImage: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIToolbar!
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    var memedImage: UIImage!
    
    //constant defining text attributes that have been applied to the meme text fields.
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
        NSAttributedString.Key.strokeWidth: 3.0
    ]
    
    //MARK: - Structs
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
       var memedImage: UIImage
    }
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Text Field attributes are set here.
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        bottomText.textAlignment = .center
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: -Actions
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
        }
    
    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: -Functions & Things
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        memeImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

//shifts the view up when the keyboardWillShow notification comes.
@objc func keyboardWillShow (_ notification:Notification) {
    view.frame.origin.y -= getKeyboardHeight(notification)
}

func getKeyboardHeight(_ notification:Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.cgRectValue.height
}

func subscribeToKeyboardNotifications() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
}

func unsubscribeFromKeyboardNotifications() {
    
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    
}
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    func save() {
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
        _ = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: memeImage.image!, memedImage: memedImage) 
    }

//Moves the view back down after the user dismisses the keyboard.
@objc func keyboardWillHide(_ notification:Notification) {
    view.frame.origin.y = 0
}
    
}

