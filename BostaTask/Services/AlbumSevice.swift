//
//  AlbumSevice.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation
import Combine

class AlbumService {
    @Published var albums: [Album] = []
    var albumSubscribtion: AnyCancellable?
    
    init () {
        getAlbum()
    }
    
    private func getAlbum() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums?userId=1")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
        ]
        
        self.albumSubscribtion = NetworkManager.request(request: request)
            .decode(type: [Album].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { albums in
                self.albums = albums
                self.albumSubscribtion?.cancel()
            }

    }
}
