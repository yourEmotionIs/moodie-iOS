//
//  BaseView.swift
//  guhada_ios
//
//  Created by 구하다 on 2025/01/21.
//  Copyright © 2025 iOS. All rights reserved.
//

import UIKit

open class BaseView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        backgroundColor = .clear
        
        setupSubviews()
        setupConstraints()
    }
    
    open func setupSubviews() {
        
    }
    
    open func setupConstraints() {
        
    }
}
