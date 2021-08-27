//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by Luis Alberto Rosas Arce on 26/08/21.
//

import UIKit

class MemeTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
        tableView.reloadData()
    }
    
    private func initView() {
        addScreenValues()
        configureTableView()
        addStyleToElements()
    }
    
    private func addScreenValues() {
        title = "Sent Memes"
    }
    
    private func addStyleToElements() {
        
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(MemeTableViewCell.getNib(), forCellReuseIdentifier: MemeTableViewCell.cellId)
    }

    // MARK: - IBAction
    @IBAction func newMemePressed(_ sender: UIBarButtonItem) {
        let destination = MemeEditorViewController.instanceViewController()
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true, completion: nil)
    }
}

extension MemeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemeTableViewCell.cellId, for: indexPath) as? MemeTableViewCell else { return UITableViewCell() }
        let meme = memes[indexPath.row]
        cell.configureCell(name: meme.getFormatName(), image: meme.memedImage)
        return cell
    }
    
}

extension MemeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
