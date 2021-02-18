//
//  Workout.swift
//  work it out
//
//  Created by Karl Cridland on 07/01/2021.
//

import Foundation
import UIKit

class Workout {
    
    let name: String
    var variance = 0
    var position = 0
    var isBreak = false
    var isFinal = false
    
    private let dropdown = UIView(frame: CGRect(x: 0, y: -(315+Settings.shared.upper_bound), width: UIScreen.main.bounds.width, height: 300+Settings.shared.upper_bound))
    private let block = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    private let delete = UIButton(frame: CGRect(x: 20, y: 400, width: 60, height: 60))
    
    var number = UILabel()
    private let time = UILabel()
    
    init(name: String) {
        self.name = name
    }
    
    func tile(_ i: Int, _ width: CGFloat, _ height: CGFloat) -> UIView{
        let activities = Settings.shared.home!.activities
        tile = UIView(frame: CGRect(x: 10+CGFloat(i%2)*(width+30)+(activities.frame.width*(CGFloat(i/6))), y: CGFloat((i/2)%3)*(height+20), width: width, height: height))
        tile.backgroundColor = .white
        tile.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tile.layer.shadowOpacity = 0.2
        tile.layer.shadowOffset = .init(width: 0, height: 10)
        tile.layer.shadowRadius = 10
        tile.layer.cornerRadius = 10
        
        number = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        number.text = String(position+1)
        number.font = .systemFont(ofSize: 40, weight: UIFont.Weight(0.9))
        number.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        number.textAlignment = .center
        number.alpha = 0.2
        
        let title = UILabel(frame: CGRect(x: 10, y: 15, width: width-20, height: 20))
        title.text = "\(name)"
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 14, weight: UIFont.Weight(0.9))
        
        let edit = UIButton(frame: CGRect(x: width-40, y: height-40, width: 25, height: 25))
        edit.setImage(UIImage(named: "edit"), for: .normal)
        
        edit.addTarget(self, action: #selector(expand), for: .touchUpInside)
        setUpDropdown()
        
        time.frame = CGRect(x: 20, y: height-40, width: width-65, height: 25)
        time.font = title.font
        tile.addSubview([number,edit,title,time])
        change_variance(sender: UIButton())
        
        return tile
    }
    
    private var tile = UIView()
    private var isExpanded = false
    
    func setUpDropdown(){
        dropdown.removeAll(false)
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
        
        self.delete.layer.cornerRadius = 30
        self.delete.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        self.delete.setImage(UIImage(named: "trash"), for: .normal)
        
        self.delete.addTarget(self, action: #selector(delete_workout), for: .touchUpInside)
        
        let title = UILabel(frame: CGRect(x: 20, y: Settings.shared.upper_bound+20, width: UIScreen.main.bounds.width-40, height: 35))
        title.clipsToBounds = false
        title.text = "\(name)"
        title.font = .systemFont(ofSize: 30, weight: UIFont.Weight(0.5))
        
        let pos = UILabel(frame: CGRect(x: 40, y: dropdown.frame.height-140, width: UIScreen.main.bounds.width-80, height: 35))
        pos.clipsToBounds = false
        pos.text = "position:"
        pos.font = .systemFont(ofSize: 20, weight: UIFont.Weight(0.5))
        
        let variance = UILabel(frame: CGRect(x: 40, y: dropdown.frame.height-70, width: UIScreen.main.bounds.width-80, height: 35))
        variance.clipsToBounds = false
        variance.text = "variance:"
        variance.font = .systemFont(ofSize: 20, weight: UIFont.Weight(0.5))
        
        let left = UIButton(frame: CGRect(x: dropdown.frame.width/2, y: pos.frame.minY-2.5, width: 40, height: 40))
        left.addTarget(self, action: #selector(change_position), for: .touchUpInside)
        left.tag = -1
        left.setImage(UIImage(named: "left"), for: .normal)
        
        let right = UIButton(frame: CGRect(x: dropdown.frame.width-70, y: pos.frame.minY-2.5, width: 40, height: 40))
        right.addTarget(self, action: #selector(change_position), for: .touchUpInside)
        right.tag = 1
        right.setImage(UIImage(named: "right"), for: .normal)
        
        let less = UIButton(frame: CGRect(x: dropdown.frame.width/2, y: variance.frame.minY-2.5, width: 40, height: 40))
        less.addTarget(self, action: #selector(change_variance), for: .touchUpInside)
        less.tag = -1
        less.setImage(UIImage(named: "minus"), for: .normal)
        
        let more = UIButton(frame: CGRect(x: dropdown.frame.width-70, y: variance.frame.minY-2.5, width: 40, height: 40))
        more.addTarget(self, action: #selector(change_variance), for: .touchUpInside)
        more.tag = 1
        more.setImage(UIImage(named: "plus"), for: .normal)
        
        for button in [left,right,less,more]{
            button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            button.layer.cornerRadius = 5
            button.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = .init(width: 0, height: 5)
            button.layer.shadowRadius = 5
        }
        
        p = UILabel(frame: CGRect(x: left.frame.maxX, y: left.frame.minY, width: right.frame.minX-left.frame.maxX, height: left.frame.height))
        p.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        p.textAlignment = .center
        p.font = .systemFont(ofSize: 20, weight: UIFont.Weight(0.5))
        p.text = "\(position+1)"
        
        v = UILabel(frame: CGRect(x: less.frame.maxX, y: less.frame.minY, width: more.frame.minX-less.frame.maxX, height: less.frame.height))
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 20, weight: UIFont.Weight(0.5))
        v.text = "\(self.variance)s"
        
        self.dropdown.addSubview([p,v,variance,pos,left,right,less,more,title])
        self.block.addSubview(self.delete)
        
    }
    
    var p = UILabel()
    
    @objc func change_position(sender: UIButton){
        let proposed = sender.tag + position
        if (proposed < Session.shared.workouts.count && proposed >= 0){
            let swap = Session.shared.workouts[proposed]
            swap.position = position
            self.position = proposed
            Session.shared.workouts.sort(by: {$0.position < $1.position})
            if let home = Settings.shared.home{
                home.update_activities()
            }
        }
        p.text = "\(position+1)"
        self.number.text = p.text!
    }
    
    var v = UILabel()
    
    @objc func change_variance(sender: UIButton){
        variance = sender.tag + variance
        
        if variance < -Session.shared.interval + 5{
            variance = -Session.shared.interval + 5
        }
        
        v.text = "\(self.variance)s"
        if (variance == 0){
            self.time.isHidden = true
            return
        }
        self.time.isHidden = false
        if (variance > 0){
            self.time.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self.time.text = "+"+v.text!
        }
        else{
            self.time.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.time.text = v.text
        }
    }
    
    @objc func delete_workout(){
        Session.shared.workouts.remove(at: position)
        if let home = Settings.shared.home{
            home.update_activities()
        }
        expand()
    }
    
    @objc func expand(){
        isExpanded = !isExpanded
        change_position(sender: UIButton())
        if let home = Settings.shared.home{
            var a = CGFloat(0)
            var y = CGFloat(0)
            if (isExpanded){
                a = 1
                self.block.alpha = 0
                self.delete.transform = CGAffineTransform(scaleX: 0, y: 0)
                home.view.addSubview(self.block)
                
            }
            else{
                y = -(315+Settings.shared.upper_bound)
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
                    self.block.removeFromSuperview()
                })
                self.delete.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.block.alpha = a
                self.delete.transform = CGAffineTransform(scaleX: CGFloat(a), y: CGFloat(a))
                self.dropdown.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 300+Settings.shared.upper_bound)
            })
            
            Session.shared.save()
        }
        
    }
    
}
