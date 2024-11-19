//
//  ImageService.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation
import UIKit
import Combine

class ImageService {
    @Published var photos: [Photo] = []
    var photoSubscribtion: AnyCancellable?
    
    init (id: Int) {
        getImages(albumId: id)
    }
    
    private func getImages(albumId: Int) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
        ]
        
        self.photoSubscribtion = NetworkManager.request(request: request)
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { photos in
                self.photos = photos
                self.photoSubscribtion?.cancel()
            }

    }
}
