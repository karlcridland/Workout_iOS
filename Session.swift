//
//  Session.swift
//  work it out
//
//  Created by Karl Cridland on 07/01/2021.
//

import Foundation
import UIKit

class Session {
    
    public static let shared = Session()
    private let defaults = UserDefaults.standard
    var workouts = [Workout]()
    var interval = 30
    var repeats = 1
    var break_time = 30
    var timer: Timer?
    var current: WorkoutSegment?
    var isPaused = false
    var progressBar = UIView()
    
    private init() {}
    
    func load() {
        if let interval = defaults.value(forKey: "interval") as? Int{
            self.interval = interval
        }
        if let repeats = defaults.value(forKey: "repeats") as? Int{
            self.repeats = repeats
        }
        if let break_time = defaults.value(forKey: "break") as? Int{
            self.break_time = break_time
        }
    }
    
    func save(){
        defaults.setValue(self.repeats, forKey: "repeats")
        defaults.setValue(self.interval, forKey: "interval")
        defaults.setValue(self.break_time, forKey: "break")
    }
    
    func startWorkout() -> UIView{
        let background = SessionBackground(frame: CGRect(x: 0, y: Settings.shared.upper_bound, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-Settings.shared.upper_bound))
        if let s = Settings.shared.home?.view.superview{
            background.layer.cornerRadius = s.layer.cornerRadius
        }
        background.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        if let h = Settings.shared.home{
            h.view.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        }
        
        let home = UIButton(frame: CGRect(x:  background.frame.width-70, y: 10, width: 40, height: 40))
        home.setTitle("cancel", for: .normal)
        home.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.9))
        home.contentMode = .scaleAspectFit
        home.setImage(UIImage(named: "stop_workout"), for: .normal)
        home.layer.cornerRadius = 10
        
        let pause = UIButton(frame: CGRect(x: background.frame.width-130, y: 10, width: 40, height: 40))
        pause.setTitle("pause", for: .normal)
        pause.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.9))
        pause.contentMode = .scaleAspectFit
        pause.setImage(UIImage(named: "pause_workout"), for: .normal)
        pause.layer.cornerRadius = 10
        
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        bg.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        progressBar.frame = CGRect(x: 0, y: 77, width: 0, height: 3)
        progressBar.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        background.addSubview([bg,progressBar])
        
        background.title.text = "sit ups"
        for a in [home,pause]{
            a.layer.shadowColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            a.layer.shadowOpacity = 0.6
            a.layer.shadowOffset = .init(width: 0, height: 5)
            a.layer.shadowRadius = 15
            background.addSubview(a)
        }
        
        home.addTarget(self, action: #selector(homeClicked), for: .touchUpInside)
        pause.addTarget(self, action: #selector(pause_timer), for: .touchUpInside)
        
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: background.frame.height-80))
        background.addSubview(scroll)
        
        scroll.isUserInteractionEnabled = false
        
        var segments = [WorkoutSegment]()
        
        var i = 0
        
        for _ in 0 ... Session.shared.repeats{
            for workout in workouts{
                let segment = WorkoutSegment(workout,i)
                segments.append(segment)
                scroll.addSubview(segment)
                i += 1
                
                if (self.break_time > 0){
                    let b = Workout(name: "break")
                    let break_segment = WorkoutSegment(b,i)
                    break_segment.isBreak()
                    segments.append(break_segment)
                    scroll.addSubview(break_segment)
                    i += 1
                }
            }
        }
        
        if (self.break_time == 0){
            let b = Workout(name: "break")
            let break_segment = WorkoutSegment(b,i)
            break_segment.isBreak()
            segments.append(break_segment)
            scroll.addSubview(break_segment)
            i += 1
        }
        
        segments.last!.final()
        var previous: WorkoutSegment?
        var p = 0
        for segment in segments{
            if (previous != nil){
                previous!.next_segment = segment
                if (previous!.workout.isBreak){
                    p += self.break_time
                }
                else{
                    p += previous!.workout.variance + self.interval
                }
                segment.progress = p
            }
            previous = segment
        }
        
        scroll.contentSize = CGSize(width: scroll.frame.width, height: (segments.last?.frame.maxY)!+40)
        segments.first!.start(nil)
        
        return background
        
    }
    
    @objc func pause_timer(sender: UIButton){
        isPaused = !isPaused
        if (isPaused){
            sender.setImage(UIImage(named: "play_workout"), for: .normal)
            if let timer = timer{
                timer.invalidate()
            }
        }
        else{
            sender.setImage(UIImage(named: "pause_workout"), for: .normal)
            if let workout = current{
                workout.start(workout.c)
            }
        }
    }
    
    @objc func homeClicked(){
        if let home = Settings.shared.home{
            home.reset()
        }
    }
    
    func updateProgress(_ workout: WorkoutSegment){
        let p = (CGFloat(100)/CGFloat(totalTime()))*CGFloat(workout.progress)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.progressBar.frame = CGRect(x: 0, y: self.progressBar.frame.minY, width: (p/100)*UIScreen.main.bounds.width, height: self.progressBar.frame.height)
        })
    }
    
    func totalTime() -> Int{
        var total  = 0
        for _ in 0 ... repeats{
            for workout in workouts{
                total += workout.variance + interval
            }
        }
        return total + (break_time*(repeats*(workouts.count))) - break_time
    }
    
    func returnToHomeScreen() {
        if let home = Settings.shared.home{
            home.reset()
        }
    }
    
    func ready() -> Bool{
        return workouts.count > 0
    }
    
}

class SessionBackground: UIView {
    let title: UILabel
    let clock = UIImageView()
    
    override init(frame: CGRect) {
        title = UILabel(frame: CGRect(x: 20, y: 100, width: frame.width-40, height: 40))
        super .init(frame: frame)
        title.textAlignment = .center
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.font = .systemFont(ofSize: 23, weight: UIFont.Weight(0.9))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
