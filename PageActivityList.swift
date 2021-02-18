//
//  PageActivityList.swift
//  work it out
//
//  Created by Karl Cridland on 10/01/2021.
//

import Foundation
import UIKit

class PageActivityList: Page {
    
    private let desc = UIView()
    
    init(title: String, activities: [String]) {
        if (title == "all activities"){
            super .init(title: "\(title)")
        }
        else{
            var t = title
            if t.last! == "s"{
                t.removeLast()
            }
            super .init(title: "\(t) exercises")
        }
        
        self.desc.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: 200)
        self.desc.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addSubview(self.desc)
        self.view.clipsToBounds = false
        
        self.desc.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.desc.layer.shadowOpacity = 0.4
        self.desc.layer.shadowOffset = .init(width: 0, height: -5)
        self.desc.layer.shadowRadius = 10
        
        var i = 0
        for activity in activities{
            let button = HButton(frame: CGRect(x: 20, y: Settings.shared.upper_bound+(CGFloat(i)*70), width: UIScreen.main.bounds.width-110, height: 50),text: activity)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            button.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            button.addTarget(self, action: #selector(add_activity), for: .touchUpInside)
            
            let info = HButton(frame: CGRect(x: button.frame.maxX+20, y: Settings.shared.upper_bound+(CGFloat(i)*70), width: 50, height: 50),text:"")
            info.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            info.setImage(UIImage(named: "info"), for: .normal)
            info.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            info.addTarget(self, action: #selector(show_info), for: .touchUpInside)
            info.accessibilityLabel = activity
            
            view.addSubview([info,button])
            view.contentSize = CGSize(width: view.frame.width, height: button.frame.maxY+30)
            
            i += 1
        }
    }
    
    @objc func show_info(sender: UIButton){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: 0, y: Settings.shared.upper_bound, width: self.view.frame.width, height: UIScreen.main.bounds.height-Settings.shared.upper_bound-Settings.shared.lower_bound-50-self.desc.frame.height-1)
            self.desc.frame = CGRect(x: 0, y: self.view.frame.maxY+1, width: self.view.frame.width, height: self.desc.frame.height)
        })
        
        desc.removeAll(false)
        if let activity = sender.accessibilityLabel{
            let title = UILabel(frame: CGRect(x: 10, y: 10, width: desc.frame.width-20, height: 30))
            title.font = .systemFont(ofSize: 24, weight: UIFont.Weight(0.9))
            title.text = activity
            
            let pronounce = UILabel(frame: CGRect(x: 10, y: 40, width: desc.frame.width-20, height: 30))
            pronounce.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.4))
            pronounce.textColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
            pronounce.text = "/\(WorkoutInfo.shared.getPronunciation(activity)!)/"
            
            let definition = UITextView(frame: CGRect(x: 5, y: pronounce.frame.maxY, width: desc.frame.width-10, height: desc.frame.height-pronounce.frame.maxY))
            definition.text = WorkoutInfo.shared.getDescription(activity)!
            definition.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.4))
            
            desc.addSubview([title,pronounce,definition])
        }
    }
    
    @objc func add_activity(sender: HButton){
        let workout = Workout(name: sender.text)
        Session.shared.workouts.append(workout)
        Settings.shared.removeAll()
        if let home = Settings.shared.home{
            home.update_activities()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
