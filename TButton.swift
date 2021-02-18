//
//  TButton.swift
//  work it out
//
//  Created by Karl Cridland on 08/01/2021.
//

import Foundation
import UIKit

class TButton:UIView{
    
    private let image = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
    private let title: String
    private var isExpanded = false
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    var value = UILabel(frame: CGRect(x: 45, y: 5, width: 50, height: 30))
    var revert = CGRect()
    var regular = true
    
    private let explanations = [
        "repeat": "how many times will the whole workout be repeated?",
        "timer": "how long do you want each activity to last? you can adjust specific activities later",
        "break": "how long of a break do you need between each activity?"
    ]
    
    private let dropdown = UIView(frame: CGRect(x: 0, y: -(215+Settings.shared.upper_bound), width: UIScreen.main.bounds.width, height: 200+Settings.shared.upper_bound))
    private let block = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let less = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-120, y: 130+Settings.shared.upper_bound, width: 40, height: 40))
    let more = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-70, y: 130+Settings.shared.upper_bound, width: 40, height: 40))
    
    init(frame: CGRect, title: String) {
        self.title = title
        super.init(frame: frame)
        revert = frame
        addSubview([image,value,button])
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.cornerRadius = 10
        layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowRadius = 15
        image.image = UIImage(named: title)
        value.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.9))
        value.textAlignment = .center
        
        button.addTarget(self, action: #selector(expand), for: .touchUpInside)
        
        less.tag = -1
        more.tag = 1
        
        setUpDropdown()
        
        
    }
    
    func addTarget(_ target: Any?, _ action: Selector){
        more.addTarget(target, action: action, for: .touchUpInside)
        less.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setUpDropdown(){
        
        dropdown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropdown.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        dropdown.layer.shadowOpacity = 0.4
        dropdown.layer.shadowOffset = .init(width: 0, height: 10)
        dropdown.layer.shadowRadius = 35
        
        if let s = Settings.shared.home?.view.superview{
            dropdown.layer.cornerRadius = s.layer.cornerRadius
        }
        
        self.block.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.423735966)
        self.block.addSubview(self.dropdown)
        self.block.addTarget(self, action: #selector(expand), for: .touchUpInside)
        
        let explanation = UILabel(frame: CGRect(x: 20, y: Settings.shared.upper_bound+110, width: UIScreen.main.bounds.width-160, height: 80))
        explanation.font = .systemFont(ofSize: 14, weight: UIFont.Weight(0.5))
        explanation.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        explanation.numberOfLines = 0
        explanation.text = explanations[self.title]
        dropdown.addSubview(explanation)
        
        val.frame = CGRect(x: 30, y: Settings.shared.upper_bound+20, width: UIScreen.main.bounds.width-60, height: 70)
        val.font = .systemFont(ofSize: 40, weight: UIFont.Weight(0.9))
        val.textAlignment = .right
        val.text = value.text
        dropdown.addSubview(val)
        
        dropdown.addSubview([less,more])
        less.setImage(UIImage(named: "minus"), for: .normal)
        more.setImage(UIImage(named: "plus"), for: .normal)
        for button in [less,more]{
            button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            button.layer.cornerRadius = 5
            button.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = .init(width: 0, height: 5)
            button.layer.shadowRadius = 5
        }
        
    }
    
    let val = UILabel()
    
    func update(_ value: String){
        self.value.text = value
        self.val.text = value
    }
    
    @objc func expand(){
        
        if (!regular){
            return
        }
        
        isExpanded = !isExpanded
        self.removeAll(false)
        self.addSubview([image,value,button])
        
        if let home = Settings.shared.home{
            var a = CGFloat(0)
            var y = CGFloat(0)
            if (isExpanded){
                a = 1
                self.block.alpha = 0
                home.view.addSubview(self.block)
                
            }
            else{
                y = -(215+Settings.shared.upper_bound)
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
                    self.block.removeFromSuperview()
                })
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.block.alpha = a
                self.dropdown.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 200+Settings.shared.upper_bound)
            })
            
            Session.shared.save()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

