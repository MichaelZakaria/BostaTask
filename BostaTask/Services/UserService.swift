//
//  UserService.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation
import Combine

class UserService {
    @Published var users: [User] = []
    var usersSubscribtion: AnyCancellable?
    
    init () {
        getUser()
    }
    
    private func getUser() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
        ]
        
        self.usersSubscribtion = NetworkManager.request(request: request)
            .decode(type: [User].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { users in
                self.users = users
                self.usersSubscribtion?.cancel()
            }

    }
}
