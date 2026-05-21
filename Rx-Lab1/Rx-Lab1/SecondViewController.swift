//
//  NameTableViewCell.swift
//  Rx-Lab1
//
//  Created by Nemo on 20/05/2026.
//

import UIKit
import RxSwift
import RxCocoa

struct FullName {
    var firstName: String
    var lastName: String
    var displayName: String {
            [firstName, lastName]
                .filter { !$0.isEmpty }
                .joined(separator: " ")
        }
}

class SecondViewController: UIViewController {
    @IBOutlet weak var nameTable: UITableView!
    private let disposeBag = DisposeBag()
    private let arrayOfNames = [
        FullName(firstName: "Beshoy", lastName: "Nader"),
        FullName(firstName: "Mona",   lastName: "Ahmed"),
        FullName(firstName: "Ahmed",  lastName: "Essam"),
    ]
    private let arrayOfNamesAdded = [
        FullName(firstName: "Beshoy", lastName: "Nader"),
        FullName(firstName: "Mona",   lastName: "Ahmed"),
        FullName(firstName: "Ahmed",  lastName: "Essam"),
        FullName(firstName: "Ali",    lastName: "Gamal")
    ]
    private var currentData: [FullName] = []
    private let arrayPublish = PublishSubject<[FullName]>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableWithObservableCreate()
         //setupTableWithPublishSubject()
        // testCombineLatest()
        testReplaySubject()
    }
    func setUpTableWithObservableCreate(){
        let dataObservable = Observable<[FullName]>.create { observer in
            self.currentData = self.arrayOfNames
            observer.onNext(self.currentData)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.currentData = self.arrayOfNamesAdded
                observer.onNext(self.currentData)
            }
            self.nameTable.rx.itemDeleted
                .subscribe(onNext: { indexPath in
                    self.currentData.remove(at: indexPath.row)
                    observer.onNext(self.currentData)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
        dataObservable
            .bind(to: nameTable.rx.items(cellIdentifier: "cell", cellType: NameTableViewCell.self)) { index, textString, cell in
                cell.textLabel?.text = textString.displayName
            }.disposed(by: disposeBag)
    }
    func setupTableWithPublishSubject() {
        arrayPublish.bind(to: nameTable.rx.items(cellIdentifier: "cell", cellType: NameTableViewCell.self)) { index, textString, cell in
            cell.textLabel?.text = textString.displayName
        }.disposed(by: disposeBag)
        currentData = arrayOfNames
        arrayPublish.onNext(currentData)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            currentData = arrayOfNamesAdded
            arrayPublish.onNext(currentData)
        }
        nameTable.rx.itemDeleted
            .subscribe(onNext: { indexPath in
                self.currentData.remove(at: indexPath.row)
                self.arrayPublish.onNext(self.currentData)
            }).disposed(by: disposeBag)
    }
    func testCombineLatest() {
        let observable1 = Observable<Int>.create { observer in
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onCompleted()
            return Disposables.create()
        }
        let observable2 = Observable<Int>.create { observer in
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onCompleted()
            return Disposables.create()
        }
        Observable.combineLatest(observable1, observable2).subscribe { value in
            print(value)
        } onCompleted: {
            print("completed")
        }.disposed(by: disposeBag)
    }
    func testReplaySubject() {
        let replaySubject = ReplaySubject<Int>.create(bufferSize: 2)
        replaySubject.onNext(1)
        replaySubject.onNext(2)
        replaySubject.onNext(3)
        replaySubject.subscribe { value in
            print("ReplaySubject →", value)
        }.disposed(by: disposeBag)
        replaySubject.onNext(4)
        replaySubject.onNext(5)
    }
}
