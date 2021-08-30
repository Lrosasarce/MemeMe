//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Luis Alberto Rosas Arce on 27/08/21.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    static let cellId = "MemeCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        memeImageView.contentMode = .scaleAspectFit
    }

    func configureCell(image: UIImage) {
        memeImageView.image = image
    }
    
    static func getNib() -> UINib? {
        return UINib(nibName: "MemeCollectionViewCell", bundle: Bundle(for: self))
    }
}
