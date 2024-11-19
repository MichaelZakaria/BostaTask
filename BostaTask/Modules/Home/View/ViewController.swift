//
//  ViewController.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var albumsTable: UITableView!
    private var albums: [Album]?
    private var viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        albumsTable.delegate = self
        albumsTable.dataSource = self
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$User
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.userName.text = user?.name
                self?.userAddress.text = user?.address.completeAddress
            }
            .store(in: &cancellables)
        
        viewModel.$albums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] albums in
                self?.albums = albums
                self?.albumsTable.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My albums"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = albums?[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumView") as! AlbumViewController
        albumVC.album = albums?[indexPath.row]
        navigationController?.pushViewController(albumVC, animated: true)
    }
}

