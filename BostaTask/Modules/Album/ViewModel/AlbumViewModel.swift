//
//  AlbumViewModel.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation
import Combine

class AlbumViewModel {
    @Published var photos: [Photo]?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let imageService: ImageService
    
    init (album: Album) {
        imageService = ImageService(id: album.id)
        
        imageService.$photos
            .sink { [weak self] photos in
                self?.photos = photos
            }
            .store(in: &cancellables)
    }
}
