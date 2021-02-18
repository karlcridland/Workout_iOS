//
//  WorkoutInfo.swift
//  work it out
//
//  Created by Karl Cridland on 10/01/2021.
//

import Foundation
import UIKit

class WorkoutInfo{
    
    public static let shared = WorkoutInfo()
    
    private init(){}
    
    private var info = [
        
        "sit ups": WD(pronounce: "ˈsit-ˌəp", description: "Lie down on your back.\n\nBend your legs and place feet firmly on the ground to stabilize your lower body.\n\nCross your hands to opposite shoulders or place them behind your ears, without pulling on your neck.\n\nCurl your upper body all the way up toward your knees. Exhale as you lift.\n\nSlowly, lower yourself down, returning to your starting point. Inhale as you lower.",type: [.abs]),
        
        "press ups": WD(pronounce: "ˈpres-(ˌ)əp", description: "Start in a high plank with your palms flat, hands shoulder-width apart, shoulders stacked directly above your wrists, legs extended behind you, and your core and glutes engaged.\n\nBend your elbows and lower your chest to the floor.\n\nPush through the palms of your hands to straighten your arms.\n\nRepeat.",type: [.arms,.back_]),
        
        "plank": WD(pronounce: "plank", description: "Get into forearm plank position.\n\nEnsure your elbows on the ground directly underneath your shoulders with your feet hip-width apart.\n\nMake sure your back is flat and your head and neck are in a neutral position.\n\nDrive your elbows into the floor, and squeeze your quads, glutes, and core.",type: [.abs,.arms]),
        
        "russian twists": WD(pronounce: "ruh·shn twists", description: "Sit with bent knees and your feet pressing firmly into the floor, holding a dumbbell in each hand next to your chest. Sit back slightly, keeping your spine straight. Exhale as you twist to the left, punching your right arm over to the left side. Inhale back to center, and then do the opposite side.",type: [.abs]),
        
        "cobras": WD(pronounce: "kow·bruhz", description: "To enter the pose, lie down on the stomach with legs stretched out behind and the tops of the feet on the ground, with toes pointed.\n\nPlace the hands directly under the shoulders with palms pressing against the ground and fingers pointing forward.\n\nLift the head, shoulders and chest off the floor, keeping the pubic bone on the floor, and the bottom of the ribs and abdomen on the floor.\n\nSlowly and gently arch the back, lifting the chest upward, keeping the shoulders down the back away from the ears and neck.",type: [.abs,.arms]),
        
        "leg raises": WD(pronounce: "leg rei·zuhz", description: "Lie on your back, legs straight and together.\n\nKeep your legs straight and lift them all the way up to the ceiling until your butt comes off the floor.\n\nSlowly lower your legs back down till they're just above the floor. Hold for a moment.\n\nRaise your legs back up.\n\nRepeat.",type: [.abs,.legs]),
        
        "crunches": WD(pronounce: "kruhn·chuhz", description: "Lie down on your back. Plant your feet on the floor, hip-width apart. Bend your knees and place your arms across your chest. Contract your abs and inhale.\n\nExhale and lift your upper body, keeping your head and neck relaxed.\n\nInhale and return to the starting position.",type: [.abs]),
        
        "bicep curls": WD(pronounce: "ˈbaɪ·sep kuhlz", description: "Start standing with a dumbbell in each hand. Your elbows should rest at your sides and your forearms should extend out in front of your body.\n\nBring the dumbbells all the way up to your shoulders by bending your elbows. Once at the top, hold for a second by squeezing the muscle.\n\nReverse the curl slowly and repeat.",type: [.arms]),
        
        "hammer curls": WD(pronounce: "ha·muh kuhlz", description: "Stand up straight with a dumbbell in each hand, holding them alongside you. Your palms should face your body.\n\nKeep your biceps stationary and start bending at your elbows, lifting both dumbbells.\n\nLift until the dumbbells reach shoulder-level, but don't actually touch your shoulders.",type: [.arms]),
        
        "tricep extensions": WD(pronounce: "traɪ·sep uhk·sten·shnz", description: "Start standing with your feet shoulder width apart and dumbbells held in front of you.\n\nRaise the dumbbells above your head until your arms are stretched out straight.\n\nSlowly lower the weights back behind your head, being careful not to flare your elbows out too much.",type: [.arms]),
        
        "skull crushers": WD(pronounce: "skuhl crush·er.", description: "Carefully extend your arms so the weight is above your head.\n\nBending at the elbows slowly lower the dumbbells towards your shoulders and pause\n\nThe return to start position and repeat.",type: [.arms,.back_]),
        
        "shoulder press": WD(pronounce: "showl·duh pres", description: "Sit on the bench holding two dumbbells at shoulder height with an overhand grip.\n\nPress the weights up above your head until your arms are fully extended.\n\nReturn slowly to the start position.",type: [.arms,.back_]),
        
        "bicycle kicks": WD(pronounce: "baɪ.sɪ.kəl kiks", description: "Lying on the back, fully extend the legs. The entire body should be parallel to the ground and place arms above the head or off to the side for added stability.\n\nSlowly bring the left leg toward the chest, bending at the knee as it comes to the chest. Bring it as close as it will go.\n\nWith the left leg is at the chest, bring the right leg, bending at the knee, toward the chest while at the same time, extending the left leg back to its straight position.\n\nDo not allow the legs to touch the ground at the bottom (keep them 2-6 inches above the ground). Hold the lowered position for 1-2 seconds before alternating to the other leg.",type: [.legs]),
        
        "dead bugs": WD(pronounce: "ded bʌgs", description: "Lie face up on your mat with your arms in the air above your torso and your legs in the air with your knees bent at 90-degree angles.\n\nThen, you lower opposite arm and leg toward the floor in a slow and controlled fashion.\n\nReturn to center and then repeat on the other side.",type: [.abs]),
        
        "squats": WD(pronounce: "skwɒts", description: "Start standing with feet just wider than hip-width apart, toes pointed slightly out, clasp hands at chest for balance.\n\nInitiate the movement by sending the hips back.\n\nBend knees to lower down as far as possible with chest lifted in a controlled movement.\n\nKeep lower back neutral.", type: [.legs])
        
    ]
    
    func getDescription(_ workout: String) -> String?{
        return info[workout]?.description
    }
    
    func getPronunciation(_ workout: String) -> String?{
        return info[workout]?.pronounce
    }
    
    func getList() -> [WorkoutType:[String]]{
        var l = [WorkoutType:[String]]()
        var all = [String]()
        for workout in info{
            all.append(workout.key)
            for type in workout.value.type{
                if l.keys.contains(type){
                    var temp = l[type]
                    temp?.append(workout.key)
                    l[type] = temp
                }
                else{
                    l[type] = [workout.key]
                }
            }
        }
        l[.all] = all
        return l
    }
    
}

struct WD{ // workout description
    let pronounce: String
    let description: String
    let type: [WorkoutType]
}

enum WorkoutType: String{
    case arms
    case abs
    case legs
    case back_
    case all
}
