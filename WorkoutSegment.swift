//
//  WorkoutSegment.swift
//  work it out
//
//  Created by Karl Cridland on 10/01/2021.
//

import Foundation
import UIKit

class WorkoutSegment: UIView{
    
    let workout: Workout
    var next_segment: WorkoutSegment?
    var progress = 0
    private var label = UILabel()
    private var remainder = UILabel()
    
    init(_ workout: Workout, _ i: Int){
        self.workout = workout
        super.init(frame: CGRect(x: 30, y: CGFloat(i)*70+20, width: UIScreen.main.bounds.width-60, height: 50))
        self.layer.shadowColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowRadius = 15
        self.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        self.layer.cornerRadius = 10
        
        label = UILabel(frame: CGRect(x: 20, y: 10, width: self.frame.width-40, height: 30))
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.9))
        label.text = workout.name
        self.addSubview(label)
        
        remainder = UILabel(frame: label.frame)
        remainder.font = label.font
        remainder.textAlignment = .right
        self.addSubview(remainder)
        
    }
    
    func isBreak() {
        workout.isBreak = true
    }
    
    func final() {
        label.text = "finished"
        workout.isFinal = true
    }
    
    var c = 0
    
    func start(_ resuming_from: Int?) {
        Session.shared.current = self
        self.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        Session.shared.updateProgress(self)
        
        if let scroll = self.superview as? UIScrollView{
            UIView.animate(withDuration: 0.7, animations: {
                if (scroll.contentSize.height < scroll.frame.height){
                    scroll.contentOffset = CGPoint(x: 0, y: 0)
                }
                else{
                    if (self.frame.minY - 20 < scroll.contentSize.height - scroll.frame.height){
                        scroll.contentOffset = CGPoint(x: 0, y: self.frame.minY - 20)
                    }
                    else{
                        scroll.contentOffset = CGPoint(x: 0, y: scroll.contentSize.height - scroll.frame.height)
                    }
                }
            })
            
            if (self.workout.isFinal){
                scroll.isUserInteractionEnabled = true
            }
        }
        
        var time = workout.variance + Session.shared.interval
        if workout.isBreak{
            time = Session.shared.break_time
        }
        if workout.isFinal{
            time = 0
        }
        if let r = resuming_from{
            time = r
        }
        c = time
        if (self.workout.isFinal){
            return
        }
        else{
            self.remainder.text = String(self.c)
        }
        Session.shared.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if (self.c == 1){
                timer.invalidate()
                self.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self.remainder.text = nil
                if let next_segment = self.next_segment{
                    next_segment.start(nil)
                }
            }
            else{
                if (Session.shared.isPaused){
                    timer.invalidate()
                }
                else{
                    self.remainder.text = String(self.c-1)
                    self.c -= 1
                }
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

