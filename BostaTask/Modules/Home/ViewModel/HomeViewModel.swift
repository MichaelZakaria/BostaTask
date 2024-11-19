//
//  HomeViewModel.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var User: User?
    @Published var albums: [Album]?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let userService = UserService()
    private let albumSevice = AlbumService()
    
    init () {
        userService.$users
            .sink { [weak self] users in
                self?.User = users.first
            }
            .store(in: &cancellables)
        
        albumSevice.$albums
            .sink { [weak self] albums in
                self?.albums = albums
            }
            .store(in: &cancellables)
    }
    
}
