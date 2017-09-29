//
//  TCorrectViewController.swift
//  Do
//
//  Created by NguyenThanhLuan on 26/07/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol TCorrectViewProtocol {
    func didClickNext()
}

class TCorrectViewController: UIViewController, GADBannerViewDelegate {
    
    var delegate:TCorrectViewProtocol!
    
    @IBOutlet weak var imBanner: UIImageView!
    @IBOutlet weak var emoticon: UIImageView!
    
    @IBOutlet weak var txtbanner: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    
    @IBOutlet weak var btNext: UIButton!
    
    var strDescription: String = ""
    var strUser: String = ""
    
    var adsBanner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var flapEmoticon: [UIImage] = [
            UIImage(named: "cool.png")!,
            UIImage(named: "oh.png")!,
            UIImage(named: "wow.png")!,
            UIImage(named: "wow1.png")!,
            UIImage(named: "yeah.png")!
        ]
        
        let flapindex = NSInteger(arc4random_uniform(UInt32(flapEmoticon.count)))
        imBanner.image = flapEmoticon[flapindex]
        
        txtDescription.text = strDescription
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let rand = arc4random()%3
        
        switch rand {
        case 0:
            PlaySoundManager.shared.playSound(soundType: .Sound_CorrectAns)
            break
        case 1:
            PlaySoundManager.shared.playSound(soundType: .Sound_CorrectAns1)
            break
        case 2:
            PlaySoundManager.shared.playSound(soundType: .Sound_CorrectAns2)
            break
        default:
            PlaySoundManager.shared.playSound(soundType: .Sound_CorrectAns)
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID,"aea500effe80e30d5b9edfd352b1602d"]
        adsBanner.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setDescription(description: String) -> Void {
        strDescription = description
    }
    
    func setUser(user: String) -> Void {
        strUser = user
    }
    
    @IBAction func hoitiepde_Action(_ sender: AnyObject) {
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        self.dismiss(animated: true) { 
            
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
