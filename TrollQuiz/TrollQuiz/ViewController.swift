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
        
        currentIndex = getCurrentIndex()
        
        initDataBase()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID,"aea500effe80e30d5b9edfd352b1602d"]
        adsBanner.load(request)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        initBackgroudMusic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initDataBase() -> Void {
        let databasemanager = TDatabaseManager.sharedInstance()
        
        if (databasemanager!.open("quiztroll.sqlite")) {
            
            let strquery = "SELECT * FROM tb_dvhainaohoingu"
            questions = databasemanager?.loadData(fromDB: strquery) as! [AnyObject]
            
            databasemanager?.close()
        }
    }
    
    func initBackgroudMusic() -> Void{
        let player = PlaySoundManager.shared
        player.prepareForSound()
        player.playSound(soundType: .Sound_Background)
    }
    
    func getCurrentIndex() -> NSInteger {
        
        return UserDefaults.standard.integer(forKey: "START_INDEX")
    }
    
    @IBAction func startGame_Action(_ sender: AnyObject) {
        print("**************** Start Game *********************")
        
//        if (mainview == nil) {
//            mainview = self.storyboard?.instantiateViewController(withIdentifier: "idmainview") as! TMainViewController
//            mainview.setupQuestions(question: questions)
//            mainview.setupContent(initContent: questions[currentIndex] as! [String])
//        }
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
//        PlaySoundManager.shared.stopPlaySound()
//        
//        self.present(mainview, animated: true) {
//            
//        }
        
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

