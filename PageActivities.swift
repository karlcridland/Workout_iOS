//
//  PageActivities.swift
//  work it out
//
//  Created by Karl Cridland on 08/01/2021.
//

import Foundation
import UIKit

class PageActivities: Page {
    
    init() {
        super .init(title: "activities")
        view.clipsToBounds = false
        let info = WorkoutInfo.shared.getList()
        
        var i = 0
        for key in info.keys.sorted(by: {workoutMenus[$0]! < workoutMenus[$1]!}){
            let button = HButton(frame: CGRect(x: 20, y: Settings.shared.upper_bound+(CGFloat(i)*70), width: UIScreen.main.bounds.width-40, height: 50),text: workoutMenus[key]!)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .highlighted)
            button.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.addSubview(button)
            view.contentSize = CGSize(width: view.frame.width, height: button.frame.maxY+30)
            
            button.addTarget(self, action: #selector(open_menu), for: .touchUpInside)
            button.accessibilityElements = [info[key]!]
            
            i += 1
        }
    }
    
    @objc func open_menu(sender: UIButton){
        if let results = sender.accessibilityElements?[0] as? [String]{
            let _ = PageActivityList(title: sender.titleLabel!.text!, activities: results)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


let workoutMenus: [WorkoutType: String] = [
    .abs:"core",
    .arms:"arms",
    .back_:"back",
    .legs:"legs",
    .all:"all activities"
]
