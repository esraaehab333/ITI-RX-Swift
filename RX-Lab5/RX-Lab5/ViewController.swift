//
//  ViewController.swift
//  RX-Lab5
//
//  Created by Nemo on 23/05/2026.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var helloMADLabel: UILabel!
    private var cancellables = Set<AnyCancellable>()
    let subject = PassthroughSubject<String, Never>()
    override func viewDidLoad() {
        super.viewDidLoad()
        renderHelloMADWithSubject()
        drawCountLabel()
        // Do any additional setup after loading the view.
    }
    func renderHelloMADWithSubject() {
        subject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.helloMADLabel.text = value
            }.store(in: &cancellables)
        subject.send("Hello MAD 46.")
    }
    func renderHelloMADWithPublisher() {
        let publisher = Future<String, Never> { promise in
            promise(.success("Hello MAD 46."))
        }
        publisher
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.helloMADLabel.text = value
            }.store(in: &cancellables)
    }
    // total delay
    //  in each delay increae the number before
  /*  func drawCountLabel() {
        
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        var totalDelay: Double = 0
        
        numbers.publisher
            .flatMap { number -> AnyPublisher<Int, Never> in
                
                totalDelay += Double(number)
                
                return Just(number)
                    .delay(for: .seconds(totalDelay), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] value in
                self?.countLabel.text = "\(value)"
            }
            .store(in: &cancellables)
    }*/
    
    func drawCountLabel(){
        var totalDelay = 0.0
        [1,2,3,4,5,6,7,8,9].publisher
            .flatMap{number -> AnyPublisher<Int, Never> in
                totalDelay += Double(number)
               return Just(number).delay(for: .seconds(totalDelay), scheduler: DispatchQueue.main).eraseToAnyPublisher()
            }.sink{[weak self] value in
                self?.countLabel.text = "\(value)"
            }.store(in: &cancellables)
    }
    //throttle ,debounce ,drop
    func simpleBackpressureExample() {
        (1...10000).publisher
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { value in
                print("Received:", value)
            }.store(in: &cancellables)
    }
}

