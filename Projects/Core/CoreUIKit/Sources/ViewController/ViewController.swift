//
//  ViewController.swift
//  guhada_ios
//
//  Created by 구하다 on 2025/01/21.
//  Copyright © 2025 iOS. All rights reserved.
//

import UIKit
import Combine

open class ViewController<ContentView: UIView>: ContentViewController<ContentView> {
    public override init() {
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissableIfNeeded()
    }
}

extension ViewController {
    private func setupKeyboardDismissableIfNeeded() {
        guard let keyboardDismissable = self as? KeyboardDismissable else { return }
        keyboardDismissable.setupKeyboardDismissable()
    }
}

public protocol KeyboardDismissable: UIViewController {
    func setupKeyboardDismissable()
}

extension KeyboardDismissable {
    public func setupKeyboardDismissable(cancellables: inout Set<AnyCancellable>) {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
//        tapGesture.tapPublisher
//            .sink { [weak self] _ in
//                self?.view.endEditing(true)
//            }
//            .store(in: &cancellables)
    }
}
