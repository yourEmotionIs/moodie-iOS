//
//  ContentViewController.swift
//  guhada_ios
//
//  Created by 구하다 on 2025/01/21.
//  Copyright © 2025 iOS. All rights reserved.
//

import UIKit

open class ContentViewController<ContentView: UIView>: UIViewController {
    public typealias ContentViewType = ContentView
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var contentView: ContentView {
        view as! ContentView
    }
    
    open override func loadView() {
        view = ContentView(frame: .zero)
    }
}
