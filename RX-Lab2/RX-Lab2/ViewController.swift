//
//  ViewController.swift
//  RX-Lab2
//
//  Created by Nemo on 19/05/2026.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var debounceBtn: UIButton!
    @IBOutlet weak var throttleBtn: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        func getLargeArray()->[Double]{
            var array : [Double] = []
            for i in 0...1000000{
                array.append(Double(i))
            }
            return array
        }
        Observable<[Double]>.create { observer in
            let array = getLargeArray()
            observer.onNext(array)
            observer.onCompleted()
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {el in
                let first = el[0]
                let count = el.count
                let sum = el.reduce(0,+)
                self.resultLabel.text = "First : \(first) , Count : \(count) , Sum : \(sum)"
            })
        //////////////////////////////////////////////////////////////////////////////////////////////////
        var count = 0
        var ctn = 0
        debounceBtn.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                count = count + 1
                print("Debounce \(count)")
            }).disposed(by: disposeBag)
        throttleBtn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                ctn = ctn + 1
                print("Debounce \(ctn)")
            }).disposed(by: disposeBag)
        //////////////////////////////////////////////////////////////////////////////////////////////////
        let observable2 = Observable<Int>.of(1,2,3,4,5,6,7,8,9,10)
        observable2
            .map{$0 * 5}
            .filter{$0 % 2 == 0}
            .skip(2)
            .take(10)
            .subscribe(
                onNext: { print($0) })
            .disposed(by: disposeBag)
    }

}

