//
//  AlbumViewController.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import UIKit
import Combine
import AlamofireImage
import SDWebImage

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var albumSearchBar: UISearchBar!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumCollection: UICollectionView!
    
    var album: Album?
    
    private var photos: [Photo]?
    private var viewModel: AlbumViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        albumCollection.delegate = self
        albumCollection.dataSource = self
        
        let layout = UICollectionViewCompositionalLayout{ indexPath, enviroment in
            return self.drawSection()
        }
        albumCollection.setCollectionViewLayout(layout, animated: true)
        
        albumTitle.text = album?.title
        viewModel = AlbumViewModel(album: album!)
        bindViewModel()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    private func bindViewModel() {
        viewModel?.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.photos = photos
                self?.albumCollection.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func drawSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width), heightDimension: itemSize.widthDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = albumCollection.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.indicator.startAnimating()
        cell.imageView.image = nil

        cell.imageView.af.setImage(withURL: URL(string: photos![indexPath.row].url)!, completion:  { response in
                cell.indicator.stopAnimating()
                if response.error != nil {
                    cell.indicator.stopAnimating()
                    if cell.imageView.image == nil {
                        cell.imageView.image = UIImage(systemName: "exclamationmark.triangle")
                    }
                }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoVC = self.storyboard?.instantiateViewController(identifier: "PhotoView") as! PhotoViewController
        photoVC.image = (albumCollection.cellForItem(at: indexPath) as! PhotoCollectionViewCell).imageView.image
        photoVC.imageTitle = photos?[indexPath.row].title
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        albumCollection.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let albumPhotos = viewModel?.photos else {return}
        
        if searchText.isEmpty {
            photos = albumPhotos
            } else {
                photos = albumPhotos.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }
            }
        albumCollection.reloadData()
    }
}
