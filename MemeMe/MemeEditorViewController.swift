//
//  ViewController.swift
//  Meme1.0
//
//  Created by Luis Alberto Rosas Arce on 21/08/21.
//

import UIKit

class MemeEditorViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cameraOption: UIBarButtonItem!
    @IBOutlet weak var libraryOption: UIBarButtonItem!
    @IBOutlet weak var topTextTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - Properties
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -2.0
    ]
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeNotification()
        
        //Check if camera is available
        cameraOption.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsuscribeNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setNeedsLayout()
    }
    
    // MARK: - Own methods
    private func initView() {
        addScreenValues()
        addStyleToElements()
    }
    
    private func addScreenValues() {
        topTextTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
    }
    
    private func addStyleToElements() {
        shareButton.isEnabled = false
        
        addStyleToTextField(topTextTextField)
        addStyleToTextField(bottomTextField)
        
        imagePickerView.contentMode = .scaleAspectFit
    }
    
    private func resetScreenConfiguration() {
        topTextTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    private func addStyleToTextField(_ textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func saveImage(_ memedImage: UIImage) {
        let _ = Meme(topText: topTextTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
    
    func pickImage(source: UIImagePickerController.SourceType = .photoLibrary) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = source
        present(imageController, animated: true, completion: nil)
    }
    
    // MARK: - Generator
    func generateMemedImage() -> UIImage {
        // Hide to generate image
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show after generate image
        navigationBar.isHidden = false
        toolBar.isHidden = false

        return memedImage
    }
    
    private func userDidBeginEditing(_ textField: UITextField) {
        if textField == topTextTextField && textField.text! == defaultTopText {
            textField.text = ""
        
        } else if textField == bottomTextField && textField.text! == defaultBottomText {
            textField.text = ""
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // CCheck current position and only apply if bottom TextField is in focus
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
            viewDidLayoutSubviews()
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Check if the view was moved by the keyboard so we move to initial position
        if view.frame.origin.y < 0 {
            view.frame.origin.y = 0
            viewDidLayoutSubviews()
        }
    }
    
    // MARK: - Notifications
    private func subscribeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsuscribeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - IBActions
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let memeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, error) in
            
            //Save image when is completed
            if completed {
                self.saveImage(memeImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        resetScreenConfiguration()
    }
    
    @IBAction func cameraOptionPressed(_ sender: UIBarButtonItem) {
        pickImage(source: .camera)
    }
    
    @IBAction func libraryOptionPressed(_ sender: UIBarButtonItem) {
        pickImage()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            shareButton.isEnabled = true
            imagePickerView.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension MemeEditorViewController: UINavigationControllerDelegate {
    
}

// MARK: - UITextFieldDelegate
extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userDidBeginEditing(textField)
    }
}

