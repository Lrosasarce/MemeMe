//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Luis Alberto Rosas Arce on 27/08/21.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let spaceItems: CGFloat = 3.0
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    
    
    private func initView() {
        addScreenValues()
        configureCollectionView()
        addStyleToElements()
    }
    
    private func addScreenValues() {
        title = "Sent Memes"
    }
    
    private func configureCollectionView() {
        //Define item size
        let dimension = (view.frame.size.width - (2.0 * spaceItems)) / 3.0
        flowLayout.minimumInteritemSpacing = spaceItems
        flowLayout.minimumLineSpacing = spaceItems
        flowLayout.estimatedItemSize = CGSize(width: dimension, height: dimension)
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        print("Dimension: \(dimension)")
        
        // Register cell classes
        self.collectionView!.register(MemeCollectionViewCell.getNib(), forCellWithReuseIdentifier: MemeCollectionViewCell.cellId)
        
        
    }
    
    private func addStyleToElements() {
        
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.cellId, for: indexPath) as? MemeCollectionViewCell else {
            return MemeCollectionViewCell()
        }
        //cell.configureCell(image: memes[indexPath.row].memedImage)
        cell.configureCell(image: UIImage(named: "AppIcon")!)
        return cell
    }
}
