//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Luis Alberto Rosas Arce on 27/08/21.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - IBOutlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    let spaceItems: CGFloat = 3.0
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh collection view
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    private func initView() {
        addScreenValues()
        configureCollectionView()
    }
    
    private func addScreenValues() {
        navigationItem.title = "Sent Memes"
    }
    
    private func configureCollectionView() {
        // Define item space
        flowLayout.minimumInteritemSpacing = spaceItems
        flowLayout.minimumLineSpacing = spaceItems
        
        // Register cell to collection view
        self.collectionView!.register(MemeCollectionViewCell.getNib(), forCellWithReuseIdentifier: MemeCollectionViewCell.cellId)
    }
    
    // MARK: - IBAction
    @IBAction func newMemePressed(_ sender: UIBarButtonItem) {
        let destination = MemeEditorViewController.instanceViewController()
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.cellId, for: indexPath) as? MemeCollectionViewCell else {
            return MemeCollectionViewCell()
        }
        cell.configureCell(image: memes[indexPath.row].memedImage)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (view.frame.size.width - (2.0 * spaceItems)) / 3.0
        return CGSize(width: dimension, height: dimension)
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memedImage = memes[indexPath.row].memedImage
        let destination = MemeDetailViewController.instanceViewController()
        destination.memeImage = memedImage
        navigationController?.pushViewController(destination, animated: true)
    }
}

