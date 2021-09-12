//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Luis Alberto Rosas Arce on 12/09/21.
//

import UIKit

class MemeDetailViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var memeImageView: UIImageView!
    
    // MARK: - Properties
    var memeImage: UIImage?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addScreenValues()
    }
    
    // MARK: - Private methods
    private func addScreenValues() {
        memeImageView.contentMode = .scaleAspectFit
        memeImageView.image = memeImage
    }
    
    // MARK: - Class method
    class func instanceViewController() -> MemeDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "MemeDetailViewController") as? MemeDetailViewController else {
            return MemeDetailViewController()
        }
        return viewController
    }

}
