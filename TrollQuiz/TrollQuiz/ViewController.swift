//
//  ViewController.swift
//  TrollQuiz
//
//  Created by NguyenThanhLuan on 27/07/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

import UIKit
import GameKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate, GKGameCenterControllerDelegate {
    
    @available(iOS 6.0, *)
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
       gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    
    @IBOutlet weak var btStartGame: UIButton!
    @IBOutlet weak var btSetup: UIButton!
    @IBOutlet weak var btSound: UIButton!
    
    var questions = [AnyObject]()
    var currentIndex = 0
    
    var categoryview: TCategoryViewController! = nil
    var setupview: TSetupViewController! = nil
    
    var adsBanner: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        authenticateLocalPlayer()
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            adsBanner = GADBannerView(adSize: kGADAdSizeBanner)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            adsBanner = GADBannerView(adSize: kGADAdSizeFullBanner)
        }
        
        adsBanner.adUnitID = "ca-app-pub-4039533744360639/9922458186"
        adsBanner.delegate = self
        adsBanner.rootViewController = self
        
        let rectSize = self.view.frame.size
        let bannerSize = adsBanner.frame.size
        
        adsBanner.frame = CGRect.init(origin: CGPoint.init(x: rectSize.width/2 - bannerSize.width/2, y: 20), size: adsBanner.frame.size)
        
        self.view.addSubview(adsBanner)
        
        let ranImage = Int.random(lower: 0, 3)
        var strImage = ""
        
        switch ranImage {
        case 0:
            strImage = "bamvaotoi"
            break
        case 1:
            strImage = "clickme"
            break
        case 2:
            strImage = "taptostart"
            break
        default:
            strImage = "clickme"
            break
        }
        
        btStartGame.setImage(UIImage.init(named: strImage), for: UIControlState.normal)
        
        UIApplication.shared.cancelAllLocalNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        registerDailyNoti()
        register2hourlaterNoti()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID,"aea500effe80e30d5b9edfd352b1602d"]
        adsBanner.load(request)
    }

    override func viewDidAppear(_ animated: Bool) {
        initBackgroudMusic()
    
        pulsate()
    }
    
    func pulsate() {
        
        if #available(iOS 9.0, *) {
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            
            pulse.duration = 0.6
            pulse.fromValue = 0.92
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = HUGE
            pulse.initialVelocity = 1.5
            pulse.damping = 1.0
            pulse.mass = 0.5
            
            btStartGame.layer.add(pulse, forKey: "pulse")
        } else {
            // Fallback on earlier versions
            
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.duration = 0.6
            pulse.fromValue = 0.92
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = HUGE
            
            btStartGame.layer.add(pulse, forKey: "pulse")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBackgroudMusic() -> Void{
        let player = PlaySoundManager.shared
        player.prepareForSound()
        player.playSound(soundType: .Sound_Background)
    }
    
    func registerDailyNoti() -> Void {
        
        var dateComp:DateComponents = DateComponents.init()

        dateComp.hour = 9;
        dateComp.minute = 0;
        dateComp.second = 0
        dateComp.timeZone = NSTimeZone.default
        
        let calender:NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let date = calender.date(from: dateComp as DateComponents)!
        
        let notification:UILocalNotification = UILocalNotification()
        notification.fireDate = date
        notification.alertBody = selectDatabase()
        notification.repeatInterval = NSCalendar.Unit.day
            
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func register2hourlaterNoti() -> Void {
        
        let notification:UILocalNotification = UILocalNotification()
        notification.fireDate = Date.init(timeIntervalSinceNow: 2*60*60)
        notification.alertBody = selectDatabase()
        notification.repeatInterval = NSCalendar.Unit.day
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func selectDatabase() -> String{
        let databasemanager = TDatabaseManager.sharedInstance()
        
        var result: [AnyObject]!
        var strtable = ""
        
        let catequiz = Int.random(lower: 0, 3)
        
        switch catequiz {
        case 0:
            strtable = "tb_dvhainaohoingu"
            break
        case 1:
            strtable = "tb_dvdongthucvat"
            break
        case 2:
            strtable = "tb_dvdiadanhlichsu"
            break
        case 3:
            strtable = "tb_dvkienthucthandong"
            break
        default:
            strtable = "tb_dvhainaohoingu"
            break
        }
        
        let questions: [AnyObject]!
        
        if (databasemanager!.open("quiztroll.sqlite")) {
            
            var strquery = "SELECT * FROM \(strtable)"
            questions = databasemanager?.loadData(fromDB: strquery) as! [AnyObject]
            
            let ranquestion = Int.random(lower: 0, questions.count)
            
            strquery = "Select cauhoi from \(strtable) where _id=\(ranquestion)"
            result = databasemanager?.loadData(fromDB: strquery) as! [AnyObject]
            
            databasemanager?.close()
        }
        
        if (result.count == 0) {
            return "Hey!\n Long time no see.Comeback and have fun!"
        }
        
        let obj = result[0] as! [String]
        return obj[0]
    }
    
    @IBAction func startGame_Action(_ sender: AnyObject) {
        print("**************** Start Game *********************")
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        
        if (categoryview == nil) {
            categoryview = self.storyboard?.instantiateViewController(withIdentifier: "idcategoryview") as! TCategoryViewController
        }
        
        self.present(categoryview, animated: true) { 
            
        }
    }
    
    @IBAction func setup_Action(_ sender: AnyObject){
        print("*************** Setup *******************")
        //idsetupview
        if (setupview == nil) {
            setupview = self.storyboard?.instantiateViewController(withIdentifier: "idsetupview") as! TSetupViewController
        }
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        
        self.present(setupview, animated: true) { 
            
        }
    }
    
    @IBAction func sound_Action(_ sender: AnyObject) {
        print("**************** Sound Action *********************")
        
        if(UserDefaults.standard.bool(forKey: "MUSIC_ON")){
            UserDefaults.standard.set(false, forKey: "MUSIC_ON")
            btSound.setImage(UIImage.init(named: "music_off.png"), for: UIControlState.normal)
            
            PlaySoundManager.shared.stopPlaySound()
            
            print("Music off")
        }
        else{
            UserDefaults.standard.set(true, forKey: "MUSIC_ON")
            btSound.setImage(UIImage.init(named: "music_on.png"), for: UIControlState.normal)

            PlaySoundManager.shared.playSound(soundType: .Sound_Background)
            
            print("Music on")
        }
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            }
            else if (localPlayer.isAuthenticated) {
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
            })
         } else {
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }
    
    //MARK: Ads Delegate
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            bannerView.alpha = 1
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    
}

