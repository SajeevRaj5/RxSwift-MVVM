//
//  LoginViewModel.swift
//  RxSwift-MVVM-Sample
//
//  Created by sajeev Raj on 4/21/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    var username = Variable<String>("")
    var password = Variable<String>("")
    
    let isValid: Observable<Bool>

    init() {
        isValid = Observable.combineLatest(username.asObservable(), password.asObservable()) { username, password in
            return username.count > 0 && password.count > 3
        }
    }
}
