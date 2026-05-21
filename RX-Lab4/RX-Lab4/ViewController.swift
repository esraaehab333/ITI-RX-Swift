//
//  ViewController.swift
//  RX-Lab4
//
//  Created by Nemo on 21/05/2026.
//

import UIKit
import Combine

struct Article: Decodable {
    let title:  String
    let author: String?
}

class ViewController: UIViewController {

    @IBOutlet weak var elementLabel: UILabel!
    @IBOutlet weak var autherLabel: UILabel!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDataTaskPublisher()
        DiscoverCombine()
    }
    private func DiscoverCombine(){
        print("Filter : ")
        [1,2,3,4,5].publisher.filter { $0 % 2 == 0 }
            .sink { print($0) } // 2 4
        print("Scan : ")
        [1,2,3,4].publisher.scan(0) { current, value in current + value} // 0+1 1+2 3+3 6+4
            .sink { print($0) }
        print("CompactMap : ")
        ["1", "2", "abc" , "1A" , "B" , "0.0"].publisher.compactMap { Double($0) } // 1 2 0
            .sink { print($0) }
        print("RemoveDublicate : ")
        [1,1,2,1,2,3,3].publisher.removeDuplicates()
            .sink { print($0) } // 1 2 1 2 3
        print("Collect : ")
        [1,2,3].publisher.collect()
            .sink { print($0) }
        print("Reduce : ")
        [1,2,3,4].publisher.reduce(0, +)
            .sink { print($0) } // 1+2+3+4
        print("Count : ")
        [1,2,3,4].publisher.count()
            .sink { print($0) } // 4
        print("Max : ")
        [5,1,9,3].publisher.max()
            .sink { print($0) }
        print("Min : ")
        [5,1,9,3].publisher.min()
            .sink { print($0) }
    }
    enum APIError : Error {
        case invalidURL
        case responseError(error:Error)
        case unknow
    }
    private func setUpDataTaskPublisher() {
        guard let url = URL(string: "https://raw.githubusercontent.com/DevTides/NewsApi/master/news.json") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Article].self, decoder: JSONDecoder())
            .mapError({ error -> Error in
                switch error {
                case URLError.cannotFindHost:
                    return APIError.invalidURL
                case URLError.notConnectedToInternet:
                    return APIError.responseError(error: error)
                default:
                    return APIError.unknow
                }
            }).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complition in
                switch complition {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error : \(error)")
                }
            }, receiveValue: { [weak self] news in
                self?.elementLabel.text = news[0].title
                self?.autherLabel.text = news[0].author
            }).store(in: &cancellables)
    }

}

