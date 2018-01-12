//
//  ViewController.swift
//  RxSignUp
//
//  Created by Kevin Le on 1/9/18.
//  Copyright © 2018 Kevin Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailValid: UILabel!
    @IBOutlet weak var confirmValid: UILabel!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailValid.text = Valid.Valid.rawValue
        confirmValid.text = Valid.Invalid.rawValue
        
        //1. Not using ViewModel
        let emailTextObservable = emailTextField.rx.text.map { $0 ?? "" }
        
        emailTextObservable
            .subscribe(onNext: {
                self.emailValid.text = $0.count > 0 ?
                    $0.isValidEmail() ? Valid.Valid.rawValue : Valid.Invalid.rawValue
                    : Valid.Neutral.rawValue
            }).disposed(by: disposeBag)
        
        let confirmTextObservable = confirmTextField.rx.text.map { $0 ?? "" }
        
        Observable.combineLatest(emailTextObservable, confirmTextObservable)
            .subscribe(onNext: {
                self.confirmValid.text = $1.count > 0 ?
                    $0.isValidEmail() && $0 == $1 ? Valid.Valid.rawValue : Valid.Invalid.rawValue
                    : Valid.Neutral.rawValue
            }).disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}



