//
//  MoodieLoginCoordinator.swift
//  MoodieAuth
//
//  Created by 이숭인 on 10/8/25.
//

import UIKit

public protocol MoodieLoginCoordinator {
    var onFinish: (() -> Void)? { get set }
    
    func start(with navigationController: UINavigationController)
}

public final class MoodieLoginCoordinatorImpl: MoodieLoginCoordinator {
    public var onFinish: (() -> Void)?
    
    public init () { }
    
    public func start(with navigationController: UINavigationController) {
        let loginVC = MoodieLoginViewController()
        navigationController.setViewControllers([loginVC], animated: true)
        
        onFinish?()
    }
}
