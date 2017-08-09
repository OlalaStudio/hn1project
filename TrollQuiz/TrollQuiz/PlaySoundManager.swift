//
//  PlaySoundManager.swift
//  TrollQuiz
//
//  Created by Huan Nguyen on 6/3/17.
//  Copyright © 2017 Huan Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

enum SOUND_TYPE {
    case Sound_Background
    case Sound_StartGame
    case Sound_GamveOver
    case Sound_GamveOver1
    case Sound_GamveOver2
    case Sound_GameResult
    case Sound_BtnTap
    case Sound_CorrectAns
    case Sound_CorrectAns1
    case Sound_CorrectAns2
    case Sound_WrongAns
    case Sound_WrongAns1
    case Sound_WrongAns2
    case Sound_OneHit
}

class PlaySoundManager: NSObject {
    // Can't init is singleton
    private override init() { }
    
    // MARK: Shared Instance
    
    static let shared = PlaySoundManager()
    
    // MARK: Local Variable
    
    var player: AVAudioPlayer?
    
    var isBG_sound : Bool? = false
    
    func prepareForSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound( soundType : SOUND_TYPE) {
        
        if UserDefaults.standard.bool(forKey: "MUSIC_ON") == false {
            return
        }

        
        let bundlePath = Bundle.main.path(forResource: "soundresource", ofType: "bundle")
        var path : String
        switch soundType {
        case .Sound_Background:
            path = bundlePath! + "/backgroundMusic.mp3"
        case .Sound_StartGame:
            path = bundlePath! + "/countdown.mp3"
        case .Sound_GamveOver:
            path = bundlePath! + "/win.mp3"
        case .Sound_GamveOver1:
            path = bundlePath! + "/fail.mp3"
        case .Sound_GamveOver2:
            path = bundlePath! + "/fail1.mp3"
        case .Sound_GameResult:
            path = bundlePath! + "/correctbeep.mp3"
        case .Sound_BtnTap:
            path = bundlePath! + "/click.mp3"
        case .Sound_CorrectAns:
            path = bundlePath! + "/correctbeep.mp3"
        case .Sound_CorrectAns1:
            path = bundlePath! + "/wow.mp3"
        case .Sound_CorrectAns2:
            path = bundlePath! + "/kidcherring.mp3"
        case .Sound_WrongAns:
            path = bundlePath! + "/wrongBeep.mp3"
        case .Sound_WrongAns1:
            path = bundlePath! + "/cuoideu.mp3"
        case .Sound_WrongAns2:
            path = bundlePath! + "/punch.mp3"
        case .Sound_OneHit:
            path = bundlePath! + "/click.mp3"
        }
        
        let url = URL(string: path)
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            
            if soundType == .Sound_Background || soundType == .Sound_StartGame {
                player.numberOfLoops = -1
            }
            
            player.prepareToPlay()
            player.play()
            player.volume = 0.5
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func stopPlaySound() {
        player?.stop()
    }
}
