//
//  AppCoordinator.swift
//  Moodie
//
//  Created by 이숭인 on 10/8/25.
//

import UIKit
import MoodieAuth

final class AppCoordinator {
    private let window: UIWindow?
    private let rootNavigationController = UINavigationController()
    
    private var loginCoordinator: MoodieLoginCoordinator?
//    private var mainCoordinator: MoodieMainCoordinatorImpl?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        showLoginFlow()
    }
    
    private func showLoginFlow() {
        self.loginCoordinator = MoodieLoginCoordinatorImpl()
        loginCoordinator?.start(with: rootNavigationController)
        
        loginCoordinator?.onFinish = { [weak self] in
            self?.showMainFlow()
        }
    }
    
    private func showMainFlow() {
        
    }
}
