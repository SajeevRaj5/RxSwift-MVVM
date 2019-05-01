//
//  ViewController.swift
//  RxSwift-MVVM-Sample
//
//  Created by sajeev Raj on 4/21/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var loginModel = LoginViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func configureView() {
        nextButton.setTitle("Disabled", for: .disabled)
        nextButton.setTitle("Proceed", for: .normal)
        
        usernameTextField.rx.text
            .orEmpty
            .bind(to: loginModel.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: loginModel.password)
            .disposed(by: disposeBag)
        
        loginModel.isValid
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

