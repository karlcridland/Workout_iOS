//
//  UIView.swift
//  work it out
//
//  Created by Karl Cridland on 07/01/2021.
//

import Foundation
import UIKit

extension UIView{
    
    func removeAll(_ session: Bool) {
        for subview in self.subviews{
            if session{
                if !(subview is SessionBackground){
                    subview.removeFromSuperview()
                }
            }
            else{
                subview.removeFromSuperview()
            }
        }
    }
    
    func addSubview(_ views: [UIView]){
        for view in views{
            self.addSubview(view)
        }
    }
    
}
