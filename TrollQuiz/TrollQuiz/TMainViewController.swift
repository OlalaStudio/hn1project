//
//  TMainViewController.swift
//  Do
//
//  Created by NguyenThanhLuan on 19/07/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

import UIKit
import MBRateApp
import GIFImageView
import SCLAlertView
import EZLoadingActivity
import GoogleMobileAds

enum AnwserState {
    case unknow
    case AnwserA
    case AnwserB
    case AnwserC
    case AnwserD
}

enum CategoryQuiz {
    case dovuihainao
    case diadanhlichsu
    case kienthucthandong
    case dongthucvat
}

class TMainViewController: UIViewController, TResultViewDelegate, TCorrectViewProtocol, TEndGameViewProtocol, GADBannerViewDelegate, GADRewardBasedVideoAdDelegate {
    
    @IBOutlet weak var btA: UIButton!
    @IBOutlet weak var btB: UIButton!
    @IBOutlet weak var btC: UIButton!
    @IBOutlet weak var btD: UIButton!

    @IBOutlet weak var lbA: UILabel!
    @IBOutlet weak var lbB: UILabel!
    @IBOutlet weak var lbC: UILabel!
    @IBOutlet weak var lbD: UILabel!
    
    @IBOutlet weak var txtQuestion: UILabel!
    @IBOutlet var imgEmoji: UIImageView!
    @IBOutlet weak var txtUser: UILabel!
    @IBOutlet weak var txtCount: UILabel!
    @IBOutlet weak var txtScore: UILabel!
    
    @IBOutlet weak var btMusic: UIButton!
    
    var content = [String]()
    var questions = [AnyObject]()
    
    var state: AnwserState = AnwserState.unknow
    var catequiz: CategoryQuiz = CategoryQuiz.dovuihainao
    
    var remainTurn = 5
    var yourScore = 0
    var currentIndex = 0
    
    var resultview: TResultViewController!
    var correctview: TCorrectViewController!
    var endview: TEndGameViewController!
    
    var user: String = ""
    
    var adsBanner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtScore.text = "\(yourScore)"
        
        if(UserDefaults.standard.bool(forKey: "MUSIC_ON")){
            btMusic.setImage(UIImage.init(named: "music_on.png"), for: UIControlState.normal)
        }
        else{
            btMusic.setImage(UIImage.init(named: "music_off.png"), for: UIControlState.normal)
        }
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var emoticons: [UIImage] = [
            UIImage.animatedImage(named: "funny")!,
            UIImage.animatedImage(named: "funny1")!,
            UIImage.animatedImage(named: "funny2")!,
            UIImage.animatedImage(named: "funny3")!,
            UIImage.animatedImage(named: "funny4")!,
            UIImage.animatedImage(named: "funny5")!
        ]
        
        let imemoticon: NSInteger = NSInteger(arc4random_uniform(UInt32(emoticons.count)))
        imgEmoji.image = emoticons[imemoticon]
        
        refreshMainView()
        
        state = AnwserState.unknow
        
        PlaySoundManager.shared.playSound(soundType: .Sound_StartGame)
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID,"aea500effe80e30d5b9edfd352b1602d"]
        adsBanner.load(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        btA.isEnabled = true
        btB.isEnabled = true
        btC.isEnabled = true
        btD.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentIndex() -> Int{
        
        var index = 0
        
        switch catequiz {
        case CategoryQuiz.dovuihainao:
            index = UserDefaults.standard.integer(forKey: "START_INDEX")
            break
        case CategoryQuiz.dongthucvat:
            index = UserDefaults.standard.integer(forKey: "START_INDEX_DTV")
            break
        case CategoryQuiz.kienthucthandong:
            index = UserDefaults.standard.integer(forKey: "START_INDEX_KTTD")
            break
        case CategoryQuiz.diadanhlichsu:
            index = UserDefaults.standard.integer(forKey: "START_INDEX_DDLS")
            break
        default:
            index = UserDefaults.standard.integer(forKey: "START_INDEX")
            break
        }
        
        
        return index
    }
    
    func registerCurrentIndex(cindex: Int) -> Void {
        
        switch catequiz {
        case CategoryQuiz.dovuihainao:
            UserDefaults.standard.set(cindex, forKey: "START_INDEX")
            break
        case CategoryQuiz.dongthucvat:
            UserDefaults.standard.set(cindex, forKey: "START_INDEX_DTV")
            break
        case CategoryQuiz.kienthucthandong:
            UserDefaults.standard.set(cindex, forKey: "START_INDEX_KTTD")
            break
        case CategoryQuiz.diadanhlichsu:
            UserDefaults.standard.set(cindex, forKey: "START_INDEX_DDLS")
            break
        default:
            UserDefaults.standard.set(cindex, forKey: "START_INDEX")
            break
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
    
    func selectDatabase(rowid: String, columnid: String) -> String{
        let databasemanager = TDatabaseManager.sharedInstance()
        
        var result: [AnyObject]!
        var strtable = ""
        
        switch catequiz {
        case CategoryQuiz.dovuihainao: 
            strtable = "tb_dvhainaohoingu"
            break
        case CategoryQuiz.dongthucvat:
            strtable = "tb_dvdongthucvat"
            break
        case CategoryQuiz.diadanhlichsu:
            strtable = "tb_dvdiadanhlichsu"
            break
        case CategoryQuiz.kienthucthandong:
            strtable = "tb_dvkienthucthandong"
            break
        }
        
        if (databasemanager!.open("quiztroll.sqlite")) {
            
            let strquery = "Select \(columnid) from \(strtable) where _id=\(rowid)"
            result = databasemanager?.loadData(fromDB: strquery) as! [AnyObject]
            
            databasemanager?.close()
        }
        
        if (result.count == 0) {
            
            let ranIndex = Int.random(lower: 0, 5)
            
            let result = checkResult(answer: state)
            
            if result == true {
                switch ranIndex {
                case 0:
                    return "Sao bạn biết hay vại."
                case 1:
                    return "Chuẩn như lê duẩn."
                case 2:
                    return "Bác là thiên tài à."
                case 3:
                    return "Thật không thể tin nổi."
                case 4:
                    return "Chính xác rồi đó bạn. Tiếp tục đi nào!"
                default:
                    return "Wow, Xin chúc mừng bác đã vượt qua câu hỏi vừa rồi!"
                }
            }
            else{
                switch ranIndex {
                case 0:
                    return "Quá hay luôn, không biết nói gì hơn. Chúc bạn may mắn lần sau nha."
                case 1:
                    return "Suy nghĩ kĩ rồi trả lời lại nào."
                case 2:
                    return "Báo bác tin vui là bác trả lời sai rùi nhoé.Hihi!"
                case 3:
                    return "Sai rồi nhé!"
                case 4:
                    return "Bạn trả lời hay quá. Nhưng không phải đáp án này đâu."
                default:
                    return "Cố lên nào!"
                }
            }
            
        }
        
        let obj = result[0] as! [String]
        return obj[0]
    }
    
    func initContent() -> Void {
        
        currentIndex = Int.random(lower: 0, questions.count - 1)
        content = questions[currentIndex] as! [String]
        
        questions.remove(at: currentIndex)
        
        txtQuestion.text = self.selectDatabase(rowid: content[0] , columnid: "cauhoi") //content[1]
        lbA.text = self.selectDatabase(rowid: content[0] , columnid: "a") //content[2]
        lbB.text = self.selectDatabase(rowid: content[0], columnid: "b") //content[3]
        lbC.text = self.selectDatabase(rowid: content[0], columnid: "c") //content[4]
        lbD.text = self.selectDatabase(rowid: content[0], columnid: "d") //content[5]
        
        user = self.selectDatabase(rowid: content[0], columnid: "nickname") //content[11]
        
        txtUser.text = ""
    }
    
    func setupContent(initContent : [String]) -> Void {
        content = initContent
    }
    
    func setupQuestions(question: [AnyObject]) -> Void {
        questions = question
    }
    
    func setCurrentIndex(index:NSInteger) -> Void {
        currentIndex = index;
    }
    
    func resetContent() -> Void {
        
        state = AnwserState.unknow
        
        remainTurn = 5
        yourScore = 0
        
        txtCount.text = "Lượt Ngu : \(remainTurn)"
        txtScore.text = "\(yourScore)"
    }
    
    
    
    @IBAction func backHome_Action(_ sender: AnyObject) {
        
        resetContent()
        
        self.dismiss(animated: true) { 
            
        }
    }

    @IBAction func answer_A(_ sender: AnyObject) {
        print("Answer A")
        
        state = AnwserState.AnwserA
        
        btA.isEnabled = false
        
        if (!checkResult(answer: state)) {
            
        }
        
        showResult()
    }
    
    @IBAction func answer_B(_ sender: AnyObject) {
        print("Answer B")
        
        state = AnwserState.AnwserB
        
        btB.isEnabled = false
        
        if (!checkResult(answer: state)) {
            
        }
        
        showResult()
    }
    
    @IBAction func answer_C(_ sender: AnyObject) {
        print("Answer C")
        
        state = AnwserState.AnwserC
        
        btC.isEnabled = false
        
        if (!checkResult(answer: state)) {
            
        }
        
        showResult()
    }
    
    @IBAction func answer_D(_ sender: AnyObject) {
        print("Answer D")
        
        state = AnwserState.AnwserD
        btD.isEnabled = false
        
        if (!checkResult(answer: state)) {
            
        }
        
        showResult()
    }
    
    @IBAction func music_Action(_ sender: AnyObject){
        if(UserDefaults.standard.bool(forKey: "MUSIC_ON")){
            UserDefaults.standard.set(false, forKey: "MUSIC_ON")
            btMusic.setImage(UIImage.init(named: "music_off.png"), for: UIControlState.normal)
            
            PlaySoundManager.shared.stopPlaySound()
            
            print("Music off")
        }
        else{
            UserDefaults.standard.set(true, forKey: "MUSIC_ON")
            btMusic.setImage(UIImage.init(named: "music_on.png"), for: UIControlState.normal)
            
            PlaySoundManager.shared.playSound(soundType: .Sound_StartGame)
            
            print("Music on")
        }
    }
    
    func showResult() -> Void {
        
        var strResult: String = ""
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        
        switch state {
        case .AnwserA:
            strResult = self.selectDatabase(rowid: content[0] , columnid: "gt_a") //content[7]
            break
        case .AnwserB:
            strResult = self.selectDatabase(rowid: content[0] , columnid: "gt_b") //content[8]
            break
        case .AnwserC:
            strResult = self.selectDatabase(rowid: content[0] , columnid: "gt_c") //content[9]
            break
        case .AnwserD:
            strResult = self.selectDatabase(rowid: content[0] , columnid: "gt_d") //content[10]
            break
        default:
            strResult = ""
        }
        
        let result = checkResult(answer: state)
        
        if (!result) {
            remainTurn -= 1
            
            txtCount.text = "Lượt Ngu : \(remainTurn)"
        }
        else{
            currentIndex += 1
            yourScore += 1
            
            txtScore.text = "\(yourScore)"
            
            registerCurrentIndex(cindex: currentIndex)
        }
        
        if (remainTurn == 0) {
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("Xem video", action: {
                self.remainTurn += 1
                self.watch_video()
            })
            alertView.addButton("Bỏ qua", action: { 
                self.endview = self.storyboard?.instantiateViewController(withIdentifier: "idendgameview") as! TEndGameViewController
                self.endview.delegate = self
                self.endview.setYourScore(score: self.yourScore)
                self.endview.setCategorys(cate: self.catequiz)
                
                self.currentIndex += 1

                self.registerCurrentIndex(cindex: self.currentIndex)
                
                self.resetContent()
                
                self.present(self.endview, animated: true, completion: {
                    
                })
                
            })
            
            alertView.showSuccess("Hết lượt chơi!", subTitle: "Lựa chọn xem video để có thêm lượt chơi nhé.")
        }
        else{
            if (result) {
                correctview = self.storyboard?.instantiateViewController(withIdentifier: "idcorrectview") as! TCorrectViewController
                correctview.delegate = self
                correctview.setDescription(description: strResult)
                correctview.setUser(user: user)
                
                self.present(correctview, animated: true, completion: { 
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
                })
            }
            else{
                resultview = self.storyboard?.instantiateViewController(withIdentifier: "idresultview") as! TResultViewController
                resultview.delegate = self
                resultview.setDescriptionString(description: strResult)
                resultview.setUser(User: user)
                resultview.view.frame = self.view.frame
                
                self.addChildViewController(resultview)
                self.view.addSubview(resultview.view)
                
                resultview.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                resultview.view.alpha = 0.0
                
                UIView .animate(withDuration: 0.2, animations: {
                    self.resultview.view.alpha = 1
                    self.resultview.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }) { (finised) in
                    
                    let rand = arc4random()%3
                    
                    switch rand {
                    case 0:
                        PlaySoundManager.shared.playSound(soundType: .Sound_WrongAns)
                        break
                    case 1:
                        PlaySoundManager.shared.playSound(soundType: .Sound_WrongAns1)
                        break
                    case 2:
                        PlaySoundManager.shared.playSound(soundType: .Sound_WrongAns2)
                        break
                    default:
                        PlaySoundManager.shared.playSound(soundType: .Sound_WrongAns)
                    }
                }
            }
        }
        
    }
    
    func checkResult(answer: AnwserState) -> Bool {
        
        let strAnwser = self.selectDatabase(rowid: content[0] , columnid: "dapandung") //content[6]
        var correntstate = AnwserState.unknow
        
        if (strAnwser.uppercased() == "A") {
            correntstate = AnwserState.AnwserA
        }
        else if (strAnwser.uppercased() == "B"){
            correntstate = AnwserState.AnwserB
        }
        else if (strAnwser.uppercased() == "C"){
            correntstate = AnwserState.AnwserC
        }
        else if (strAnwser.uppercased() == "D"){
            correntstate = AnwserState.AnwserD
        }
        
        if (answer == correntstate) {
            return true
        }
        
        return false
    }
    
    func refreshMainView(){
        
        currentIndex = getCurrentIndex()
        
        initContent()
        
        self.view.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.5) { 
            self.view.alpha = 1
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }
    
    //MARK: - Result View Delegate
    func didClickOnResultView() {
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.resultview.view.alpha = 0
        }, completion: { (finished) in
            self.resultview.view.removeFromSuperview()
            self.resultview.removeFromParentViewController()
        })
        
        PlaySoundManager.shared.playSound(soundType: .Sound_StartGame)
    }
    
    //MARK: - Correct View Delegate
    func didClickNext() {
        
    }
    
    // MARK: - End Game Delegate
    func didClickResumeGame(){
        
    }
    
    //MARK: Ads Delegate - Video
    func watch_video(){
        print("watch video")
        
        EZLoadingActivity.show("Loading Video...", disableUI: true)
        
        self.txtCount.text = "Lượt Ngu : \(self.remainTurn)"
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID,"aea500effe80e30d5b9edfd352b1602d"]
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-4039533744360639/3137557984")
    }
    
    func rate_action(){
        print("rate")
        self.txtCount.text = "Lượt chơi : \(self.remainTurn)"
        
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
                
            }
        }else{
            
        }
    }
    
    func share_action(){
        print("share")
        self.txtCount.text = "Lượt chơi : \(self.remainTurn)"
        
        let itunesId = "1265597029"
        
        let postText: String = "Trò này vui lắm. Chơi thử đi"
        let downloadlink:String = "http://itunes.apple.com/app/id\(itunesId)"
        
        let postImage: UIImage = getScreenshot()
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
    
    func getScreenshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions((self.view?.bounds.size)!, false, 1)
        
        self.view?.drawHierarchy(in: (self.view?.bounds)!, afterScreenUpdates: true)
        
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshotImage!
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            
            EZLoadingActivity.hide(true, animated: true)
            
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
        
        EZLoadingActivity.hide(false, animated: true)
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
}
