//
//  ViewController.swift
//  work it out
//
//  Created by Karl Cridland on 07/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    let begin = HButton(frame: .zero, text: "start workout")
    let add_workout = HButton(frame: .zero, text: "add activity")
    let options = UIScrollView()
    
    let activities = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Settings.shared.home = self
        Session.shared.load()
        
        begin.addTarget(self, action: #selector(startWorkout), for: .touchUpInside)
        add_workout.addTarget(self, action: #selector(add_workout_clicked), for: .touchUpInside)

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            if let layout = self.view.superview?.layoutMargins{
                Settings.shared.upper_bound = layout.top
                Settings.shared.lower_bound = layout.bottom
            }
            self.reset()
        })
        
    }
    
    @objc func add_workout_clicked(){
        let _ = PageActivities()
    }
    
    @objc func startWorkout(){
        if (!Session.shared.ready()){
            return
        }
        
        self.view.bringSubviewToFront(self.begin)
        
        self.view.addSubview(Countdown())
        
        UIView.animate(withDuration: 0.3, animations: {
            self.begin.frame = self.view.frame
            self.begin.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
            self.begin.setTitleColor(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1), for: .normal)
            
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            
        })
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.view.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        })
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { _ in
            self.view.addSubview(Session.shared.startWorkout())
        })
    }
    
    @objc func reset(){
        self.view.removeAll(false)
        self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.9607843137, alpha: 1)
        
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
        
        self.setUpOptions()
        
        self.add_workout.frame = CGRect(x: 20, y: Settings.shared.upper_bound+80, width: view.frame.width-40, height: 50)
        self.add_workout.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        self.add_workout.setTitleColor(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), for: .highlighted)
        self.add_workout.layer.shadowColor = #colorLiteral(red: 0.7949568629, green: 0.5719817877, blue: 0.4843166471, alpha: 1)
        
        self.begin.setTitleColor(.white, for: .normal)
        self.begin.alpha = 1
        self.begin.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.begin.frame = CGRect(x: UIScreen.main.bounds.width/2-100, y: UIScreen.main.bounds.height-Settings.shared.lower_bound-75, width: 200, height: 45)
        
        self.activities.frame = CGRect(x: 10, y: add_workout.frame.maxY+30, width: UIScreen.main.bounds.width-20, height: begin.frame.minY-(add_workout.frame.maxY+60))
        self.activities.isPagingEnabled = true
        self.activities.showsHorizontalScrollIndicator = false
        
        self.view.addSubview([self.options,self.begin,self.add_workout, self.activities])
        
        update_activities()
    }
    
    func update_activities(){
        var x = activities.contentOffset.x
        activities.removeAll(false)
        activities.clipsToBounds = false
        let width = activities.frame.width/2-30
        let height = (activities.frame.height-40)/3
        
        var i = 0
        for workout in Session.shared.workouts{
            let tile = workout.tile(i,width,height)
            workout.position = i
            activities.addSubview(tile)
            workout.number.text = String(i+1)
            i += 1
        }
        
        if (x == activities.contentSize.width && x != 0){
            x -= activities.frame.width
        }
        activities.contentSize = CGSize(width: activities.frame.width*(CGFloat((i-1)/6)+1), height: activities.frame.height)
        activities.contentOffset = CGPoint(x: x, y: 0)
    }
    
    var timer_button: TButton?
    var repeat_button: TButton?
    var break_button: TButton?
    
    func setUpOptions(){
        self.options.frame = CGRect(x: 0, y: Settings.shared.upper_bound, width: view.frame.width, height: 60)
        
        self.options.clipsToBounds = false
        
        self.options.removeAll(false)
        
        let menu_button = TButton(frame: CGRect(x: 20, y: 10, width: 110, height: 40), title: "menu")
        
        menu_button.frame = .zero
        menu_button.clipsToBounds = true
        
        timer_button = TButton(frame: CGRect(x: menu_button.frame.maxX+20, y: 10, width: 100, height: 40), title: "timer")
        break_button = TButton(frame: CGRect(x: timer_button!.frame.maxX+20, y: 10, width: 100, height: 40), title: "break")
        repeat_button = TButton(frame: CGRect(x: break_button!.frame.maxX+20, y: 10, width: 100, height: 40), title: "repeat")
        options.contentSize = CGSize(width: repeat_button!.frame.maxX+20, height: 60)
        self.options.showsHorizontalScrollIndicator = false
        
        menu_button.regular = false
        menu_button.button.addTarget(self, action: #selector(open_menu), for: .touchUpInside)
        
        menu_button.update("menu")
        timer_button!.update("\(Session.shared.interval)s")
        repeat_button!.update("\(Session.shared.repeats)")
        break_button!.update("\(Session.shared.break_time)s")
        
        timer_button!.addTarget(self, #selector(change_timer))
        repeat_button!.addTarget(self, #selector(change_repeat))
        break_button!.addTarget(self, #selector(change_break))
        
        options.addSubview([menu_button,timer_button!,repeat_button!,break_button!])
        
    }
    
    @objc func open_menu(){
        let _ = PageMenu()
    }
    
    @objc func change_timer(sender: UIButton){
        Session.shared.interval += sender.tag
        if Session.shared.interval < 10{
            Session.shared.interval = 10
        }
        for workout in Session.shared.workouts{
            workout.change_variance(sender: UIButton())
        }
        timer_button?.update("\(Session.shared.interval)s")
    }
    
    @objc func change_repeat(sender: UIButton){
        Session.shared.repeats += sender.tag
        if Session.shared.repeats < 0{
            Session.shared.repeats = 0
        }
        repeat_button?.update(String(Session.shared.repeats))
        
    }
    
    @objc func change_break(sender: UIButton){
        Session.shared.break_time += sender.tag
        if Session.shared.break_time < 0{
            Session.shared.break_time = 0
        }
        break_button?.update("\(Session.shared.break_time)s")
        
    }

}
