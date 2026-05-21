import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var switchbtn: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  let observable1: Observable<Int> = Observable<Int>.just(1)
        let observable2: Observable<String> = Observable<String>.of("Esraa", "Mona", "Hend", "Tasneem")[[],[]]
        let observable3: Observable<String> = Observable<String>.from(["Esraa", "Mona", "Hend", "Tasneem"])//flat
        let observable4: Observable<String> = Observable.create {
            observer in
            observer.onNext("Esraa")
            observer.onNext("Mai")
            observer.onCompleted()
            observer.onNext("Hend")
            return Disposables.create()
        }
        observable1.subscribe(
            onNext: { value in
                print("observable1: \(value)")
            }).disposed(by: disposeBag)
        observable2.subscribe(
            onNext: { value in
                print("observable2: \(value)")
            }).disposed(by: disposeBag)
        observable3.subscribe(
            onNext: { value in
                print("observable3: \(value)")
            }).disposed(by: disposeBag)
        observable4.subscribe(
            onNext: { value in
                print("observable4: \(value)")
            }).disposed(by: disposeBag)
        switchbtn.rx.isOn.subscribe(
            onNext: { isOn in // wek self
                self.statusLabel.text = isOn ? "On" : "Off"
            },onCompleted: {
                print("switch complete")
            }).disposed(by: disposeBag)*/
    }
}
