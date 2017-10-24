//
//  TEndGameViewController.swift
//  Do
//
//  Created by NguyenThanhLuan on 20/07/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

import UIKit
import GameKit
import GoogleMobileAds
import SCLAlertView

protocol TEndGameViewProtocol {
    func didClickResumeGame()
}

class TEndGameViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, GKGameCenterControllerDelegate{

    var delegate:TEndGameViewProtocol!
    
    @IBOutlet weak var txtEnd: UILabel!
    @IBOutlet weak var emoticon: UIImageView!
    @IBOutlet weak var btChoTiep: UIButton!
    @IBOutlet weak var txtYourScore: UILabel!
    @IBOutlet weak var txtHighScore: UILabel!
    
    var catequiz: CategoryQuiz = CategoryQuiz.dovuihainao
    
    var yourScore = 0
    var highScore = 0
    
    var adsBanner: GADBannerView!
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        print("%d",yourScore)
        
        highScore = UserDefaults.standard.integer(forKey: "HIGH_SCORE")
        
        if (yourScore > highScore) {
            highScore = yourScore
            
            UserDefaults.standard.set(highScore, forKey: "HIGH_SCORE")
            txtEnd.text = "High score!.\nChúc mừng bạn"
            
            let rConnection = Reachability.forInternetConnection()
            let status = rConnection?.currentReachabilityStatus()
            
            if (status != NotReachable && GKLocalPlayer.localPlayer().isAuthenticated == true) {
                commitHighScore()
            }
        }
        else{
            txtEnd.text = "Bạn đã hết lượt chơi"
        }
        
        txtYourScore.text = "Bạn trả lời đc \(yourScore)/1000 câu hỏi"
        txtHighScore.text = "Thành tích tốt nhất của bạn : \(highScore)"
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            adsBanner = GADBannerView(adSize: kGADAdSizeBanner)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            adsBanner = GADBannerView(adSize: kGADAdSizeLeaderboard)
        }
        
        adsBanner.adUnitID = "ca-app-pub-4039533744360639/9922458186"
        adsBanner.delegate = self
        adsBanner.rootViewController = self
        
        let rectSize = self.view.frame.size
        let bannerSize = adsBanner.frame.size
        
        adsBanner.frame = CGRect.init(origin: CGPoint.init(x: rectSize.width/2 - bannerSize.width/2, y: rectSize.height - bannerSize.height), size: adsBanner.frame.size)
        
        self.view.addSubview(adsBanner)
        
        interstitial = createAndLoadInterstitial()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID,"aea500effe80e30d5b9edfd352b1602d"]
        adsBanner.load(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if highScore == yourScore {
            PlaySoundManager.shared.playSound(soundType: .Sound_GamveOver)
        }
        else{
            let rand = arc4random()%2
            
            switch rand {
            case 0:
                PlaySoundManager.shared.playSound(soundType: .Sound_GamveOver1)
                break
            case 1:
                PlaySoundManager.shared.playSound(soundType: .Sound_GamveOver2)
                break
            default:
                PlaySoundManager.shared.playSound(soundType: .Sound_GamveOver)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setYourScore(score: NSInteger) -> Void {
        yourScore = score
    }
    
    func setCategorys(cate:CategoryQuiz) -> Void {
        catequiz = cate
    }
    
    func commitHighScore() -> Void {
        
        //identifier
        let bestScoreInt: GKScore!
        
        switch catequiz {
        case CategoryQuiz.dovuihainao:
            bestScoreInt = GKScore(leaderboardIdentifier: "com.OlaStudio.tophoinguhainao")
            break
        case CategoryQuiz.dongthucvat:
            bestScoreInt = GKScore(leaderboardIdentifier: "com.OlaStudio.topkienthuclichsu")
            break
        case CategoryQuiz.diadanhlichsu:
            bestScoreInt = GKScore(leaderboardIdentifier: "com.OlaStudio.topdongthucvat")
            break
        case CategoryQuiz.kienthucthandong:
            bestScoreInt = GKScore(leaderboardIdentifier: "com.OlaStudio.topkienthucthandong")
            break
        default:
            bestScoreInt = GKScore(leaderboardIdentifier: "com.OlaStudio.tophoinguhainao")
            break
        }
        
        bestScoreInt.value = Int64(highScore)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                print("Best Score submitted to your Leaderboard!")
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                
                let alertView = SCLAlertView(appearance: appearance)
                
                alertView.addButton("Xem Bảng Xếp Hạng", action: {
                    self.show_leaderboard()
                })
                alertView.addButton("Bỏ qua", action: {
                    
                })
                
                alertView.showSuccess("High score!", subTitle: "Bạn vừa đạt mức high score. Xem vị trí của bạn trên bảng xếp hạng")
            }
        }
        
    }

    @IBAction func choiTiep_Action(_ sender: AnyObject) {
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        self.dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func menu_Action(_ sender: AnyObject) {
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
            
        })
    }
    
    @IBAction func rate_Action(_ sender: AnyObject) {
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        
        show_leaderboard()
    }
    
    func show_leaderboard(){
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        present(gcVC, animated: true, completion: nil)
    }
    
    @available(iOS 6.0, *)
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Ads Delegate - Banner
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
    
    //MARK: Ads Delegate - interatial
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4039533744360639/8581456350")
        interstitial.delegate = self
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID,"aea500effe80e30d5b9edfd352b1602d"]
        
        interstitial.load(request)
        
        return interstitial
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}
