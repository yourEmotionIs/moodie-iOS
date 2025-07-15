//
//  UITableView+Extension.swift
//  guhada_ios
//
//  Created by 이숭인 on 3/20/25.
//  Copyright © 2025 iOS. All rights reserved.
//

import UIKit
import Combine

private var prepareForReuseSubjectKey: UInt8 = 0

extension UITableViewCell {
    var prepareForReuseSubject: PassthroughSubject<Void, Never> {
        if let subject = objc_getAssociatedObject(self, &prepareForReuseSubjectKey) as? PassthroughSubject<Void, Never> {
            return subject
        } else {
            let subject = PassthroughSubject<Void, Never>()
            objc_setAssociatedObject(self, &prepareForReuseSubjectKey, subject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return subject
        }
    }
    
    @objc func swizzled_prepareForReuse() {
        prepareForReuseSubject.send(())
        swizzled_prepareForReuse()
    }
    
    public static func swizzlePrepareForReuse() {
        let originalSelector = #selector(UITableViewCell.prepareForReuse)
        let swizzledSelector = #selector(UITableViewCell.swizzled_prepareForReuse)
        
        guard let originalMethod = class_getInstanceMethod(UITableViewCell.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UITableViewCell.self, swizzledSelector) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
