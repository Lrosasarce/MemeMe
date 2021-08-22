//
//  ViewController.swift
//  Meme1.0
//
//  Created by Luis Alberto Rosas Arce on 21/08/21.
//

import UIKit

enum TabBarOption: Int {
    case camera = 0
    case library = 1
}

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cameraOption: UITabBarItem!
    @IBOutlet weak var libraryOption: UITabBarItem!
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
        .strokeWidth: -3.0
    ]
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeNotification()
        cameraOption.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsuscribeNotification()
    }
    
    // MARK: - Own methods
    private func initView() {
        tabBar.delegate = self
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

    private func addStyleToTextField(_ textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .allCharacters
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func saveImage(_ memedImage: UIImage) {
        let meme = Meme(topText: topTextTextField.text!, bottomText: self.bottomTextField.text!, image: self.imagePickerView.image!, memedImage: memedImage)
    }
    
    // MARK: - Generator
    func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        tabBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        tabBar.isHidden = false

        return memedImage
    }
    
    // MARK: - Notifications
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    private func subscribeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsuscribeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //MARK: - IBActions
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let memeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, error) in
            if completed {
                self.saveImage(memeImage)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        topTextTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        imagePickerView.image = nil
    }
    
}

// MARK: - UITabBarDelegate
extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let option = TabBarOption(rawValue: item.tag)
        
        switch option {
        case .camera:
            let imacController = UIImagePickerController()
            imacController.delegate = self
            imacController.sourceType = .camera
            self.present(imacController, animated: true, completion: nil)
            break
            
        case .library:
            let imacController = UIImagePickerController()
            imacController.delegate = self
            imacController.sourceType = .photoLibrary
            self.present(imacController, animated: true, completion: nil)
            break
            
        case .none: break
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.shareButton.isEnabled = true
            self.imagePickerView.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextTextField {
            if textField.text! == defaultTopText {
                textField.text = ""
            }
        }
        
        if textField == bottomTextField {
            if textField.text! == defaultBottomText {
                textField.text = ""
            }
        }
    }
}

