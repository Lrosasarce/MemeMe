//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Luis Alberto Rosas Arce on 26/08/21.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeNameLabel: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!
    
    static let cellId = "MemeTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        addStyleToElements()
    }
    
    private func addStyleToElements() {
        selectionStyle = .none
        
        memeNameLabel.numberOfLines = 0
        memeNameLabel.textAlignment = .center
        
        memeImageView.contentMode = .scaleAspectFit
    }
    
    
    func configureCell(name: String, image: UIImage) {
        memeNameLabel.text = name
        memeImageView.image = image
    }
    
    class func getNib() -> UINib? {
        return UINib(nibName: "MemeTableViewCell", bundle: Bundle(for: self))
    }
}
