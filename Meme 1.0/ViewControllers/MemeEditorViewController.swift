//
//  ViewController.swift
//  Meme 1.0
//
//  Created by Evan Barbour on 2/23/19.
//  Copyright © 2019 Evan Barbour. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIToolbarDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        configureTextField(topTextField, text: "TOP")
        configureTextField(bottomTextField, text: "BOTTOM")
    }

    
    // Pick an image from photo album / library
    func pickAnImage(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func onTapCameraButton(_ sender: Any) {
        pickAnImage(.camera)
    }
    
    @IBAction func onTapLibraryButton(_ sender: Any) {
        pickAnImage(.photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
            shareButton.isEnabled = true
        }
    }
    
    // If you want to tap outside the text field rather than hit "return" (from StackOverflow: https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    // Save the meme in the UIImageView
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(memeView.bounds.size)
        memeView.drawHierarchy(in: memeView.bounds, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // Share or save
    func keepMeme() {
        guard let originalImage = imagePickerView.image else { return }
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: originalImage, memedImage: generateMemedImage())
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // Share or save your meme
    @IBAction func onTapShareOrSave(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityController, animated: true)
        activityController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.keepMeme()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Cancel button functionality
    @IBAction func onTapCancel(_sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Textfield look and functionality
    func configureTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = self
        textField.defaultTextAttributes = [
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: -4
        ]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Keyboard behavior
    // Move the view up and down when the bottom text field is editing and done editing
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    // Notification center for keyboard behavior
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
