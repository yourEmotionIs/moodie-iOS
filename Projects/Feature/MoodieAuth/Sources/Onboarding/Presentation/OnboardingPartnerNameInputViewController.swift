//
//  OnboardingPartnerNameInputViewController.swift
//  MoodieAuth
//
//  Created by 이숭인 on 10/22/25.
//

import UIKit
import CoreUIKit
import SnapKit
import Then
import Combine
import CombineCocoa

final class OnboardingPartnerNameInputView: BaseView {
    var onTouchCompleteButton: AnyPublisher<Void, Never> {
        nextButton.tapPublisher
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
    }
    
    override func setup() {
        super.setup()
        
    }
    
    override func setupSubviews() {
        addSubview(nextButton)
    }
    
    override func setupConstraints() {
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
}

final class OnboardingPartnerNameInputViewController: ViewController<OnboardingPartnerNameInputView> {
    var navigateToNextPagePublisher: AnyPublisher<Void, Never> {
        contentView.onTouchCompleteButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
