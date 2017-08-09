//
//  TSetupViewController.swift
//  TrollQuiz
//
//  Created by NguyenThanhLuan on 29/07/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

import UIKit
import GameKit
import SCLAlertView
import MBRateApp

class TSetupViewController: UIViewController, GKGameCenterControllerDelegate {
    @available(iOS 6.0, *)
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
         gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var btback: UIButton!
    @IBOutlet weak var btbxh: UIButton!
    @IBOutlet weak var btrate: UIButton!
    @IBOutlet weak var btshare: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func back_Action(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func bxh_Action(_ sender: AnyObject) {
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        present(gcVC, animated: true, completion: nil)

    }
    
    @IBAction func rate(_ sender: AnyObject) {
        var rateUsInfo = MBRateUsInfo() //get the default settings
        
        //override any attribute
        rateUsInfo.title = "Chơi vui không bạn! :D"
        rateUsInfo.titleImage = UIImage(named: "ask2")
        rateUsInfo.itunesId = "1265597029"
        
        //set the value in the shared instance
        MBRateUs.sharedInstance.rateUsInfo = rateUsInfo
        
        if (!UserDefaults.standard.bool(forKey: "RATED")){
            MBRateUs.sharedInstance.showRateUs(base: self
                , positiveBlock: { () -> Void in
                    //code to run when the user chose more than 3 stars and chose to rate in the app store
                    SCLAlertView().showInfo("Rated!", subTitle: "Cảm ơn bạn đã góp ý")
                }, negativeBlock: { () -> Void in
                    //code to run when the user chose less than 4 stars and chose to send feedback
                    SCLAlertView().showInfo("Rated!", subTitle: "Cảm ơn bạn đã góp ý")
            }) { () -> Void in
                //code to run when the user dismissed that screen without choosing anything
                SCLAlertView().showInfo("Huỷ Bỏ", subTitle: "Bạn chưa gửi đánh giá. Chơi thêm và góp ý với chúng tôi nhé")
            }
        }else{
            SCLAlertView().showInfo("Rated!", subTitle: "Cảm ơn bạn đã góp ý")
        }
    }
    
    @IBAction func share_Action(_ sender: AnyObject) {
        let itunesId = "1265597029"
        
        let postText: String = "Trò này vui lắm. Chơi thử đi"
        let downloadlink:String = "http://itunes.apple.com/app/id\(itunesId)"
        
        let postImage: UIImage = UIImage.init(named: "icon")!
        let activityItems = [postText, postImage,downloadlink] as [Any]
        
        
        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        activityController.popoverPresentationController?.sourceView = self.view
        
        self.present(
            activityController,
            animated: true,
            completion: nil
        )

    }
}
