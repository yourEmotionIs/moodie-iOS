//
//  MoodieLoginViewController.swift
//  MoodieAuth
//
//  Created by 이숭인 on 7/23/25.
//

import UIKit
import CoreUIKit
import CoreAuthKit

public final class MoodieLoginView: BaseView {
    private let exampleLabel = UILabel(
        typography: Typography(
            fontType: .appleSDGothic,
            size: .size24,
            weight: .bold,
            color: .gray1
        )
    ).then {
        $0.text = "하하하핳하 샘플이지롱"
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray8
    }
    
    public override func setupSubviews() {
        addSubview(exampleLabel)
    }
    
    public override func setupConstraints() {
        exampleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

//TODO: 추후 DI Container에서 해당 뷰를 다룰 수 있게 바꿔야함
public final class MoodieLoginViewController: ViewController<MoodieLoginView> {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task { @MainActor in
            try await CoreAuthKit.shared.performAppleLogin()
//            try await CoreAuthKit.shared.performKakaoLogin()
        }
    }
}
