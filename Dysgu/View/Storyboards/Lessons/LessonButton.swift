//
//  LessonButton.swift
//  Dysgu
//
//  Created by Tomas Moore on 28/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class LessonButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemOrange
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 28)
        layer.cornerRadius = 10
    }
}


