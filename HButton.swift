//
//  HButton.swift
//  work it out
//
//  Created by Karl Cridland on 07/01/2021.
//

import Foundation
import UIKit

class HButton: UIButton {
    
    let text: String
    
    init(frame: CGRect, text: String) {
        self.text = text
        super .init(frame: frame)
        setTitle(text, for: .normal)
        setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .highlighted)
        backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        layer.cornerRadius = 10
        titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.9))
        layer.shadowColor = #colorLiteral(red: 0.4122892618, green: 0.6310247779, blue: 0.7813337445, alpha: 1)
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
