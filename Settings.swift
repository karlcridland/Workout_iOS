//
//  Settings.swift
//  work it out
//
//  Created by Karl Cridland on 07/01/2021.
//

import Foundation
import UIKit

class Settings{
    
    public static let shared = Settings()
    
    var home: ViewController?
    var upper_bound = CGFloat(0.0)
    var lower_bound = CGFloat(0.0)
    private var pages = [Page]()
    private let banner = UIView()
    private let back = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
    private let title = UILabel()
    
    private init() {
        let weight = CGFloat(0.6)
        banner.isHidden = true
        banner.backgroundColor = #colorLiteral(red: 0.9702429175, green: 0.9644748569, blue: 0.9746765494, alpha: 1)
        
        back.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        back.contentHorizontalAlignment = .left
        back.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(weight))
        back.setTitle("back", for: .normal)
        back.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        back.addTarget(self, action: #selector(remove), for: .touchUpInside)
        
        
        title.frame = CGRect(x: 80, y: 0, width: UIScreen.main.bounds.width-100, height: 50)
        title.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(weight))
        title.textAlignment = .right
        
        self.banner.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 50+self.lower_bound)
        banner.addSubview([back,title])
    }
    
    func append(_ page: Page){
        pages.append(page)
        banner.isHidden = false
        back.isHidden = false
        
        if let home = Settings.shared.home{
            home.view.addSubview(page)
        }
        
        
        update()
    }
    
    @objc func remove(){
        if let last = pages.last{
            last.disappear()
            pages.removeLast()
            
        }
        
        update()
        
    }
    
    func removeAll(){
        while pages.count > 0{
            remove()
        }
    }
    
    func update(){
        if let last = pages.last{
            title.text = last.title
            UIView.animate(withDuration: 0.3, animations: {
                self.banner.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-self.lower_bound-50, width: UIScreen.main.bounds.width, height: 50+self.lower_bound)
            })
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.banner.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 50+self.lower_bound)
            })
        }
        
        if let home = home{
            home.view.addSubview(banner)
        }
    }
    
}
