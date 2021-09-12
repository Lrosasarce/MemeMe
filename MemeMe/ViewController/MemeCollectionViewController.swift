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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func initView() {
        addScreenValues()
        configureCollectionView()
        addStyleToElements()
    }
    
    private func addScreenValues() {
        navigationItem.title = "Sent Memes"
    }
    
    private func configureCollectionView() {
        //Define item space
        flowLayout.minimumInteritemSpacing = spaceItems
        flowLayout.minimumLineSpacing = spaceItems
        
        self.collectionView!.register(MemeCollectionViewCell.getNib(), forCellWithReuseIdentifier: MemeCollectionViewCell.cellId)
        
        
    }
    
    private func addStyleToElements() {
        
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.cellId, for: indexPath) as? MemeCollectionViewCell else {
            return MemeCollectionViewCell()
        }
        cell.configureCell(image: memes[indexPath.row].memedImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (view.frame.size.width - (2.0 * spaceItems)) / 3.0
        return CGSize(width: dimension, height: dimension)
    }
}
