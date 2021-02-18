//
//  Countdown.swift
//  work it out
//
//  Created by Karl Cridland on 07/01/2021.
//

import Foundation
import UIKit

class Countdown: UIView {
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.displayNumber(3)
            var n = 2
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                
                if (n == 0){
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                        self.superview?.removeAll(true)
                    })
                    timer.invalidate()
                }
                else{
                    self.removeAll(true)
                    self.displayNumber(n)
                    n -= 1
                }
                
            })
        })
        
    }
    
    func displayNumber(_ n: Int) {
        let number = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        number.textAlignment = .center
        number.textColor = .white
        number.font = .systemFont(ofSize: 30, weight: UIFont.Weight(0.3))
        addSubview(number)
        UIView.animate(withDuration: 1, animations: {
            number.transform = CGAffineTransform(scaleX: 3, y: 3)
        })
        number.text = String(n)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
