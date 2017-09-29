//
//  TCategoryViewController.swift
//  TrollQuiz
//
//  Created by NguyenThanhLuan on 08/08/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

import UIKit

class TCategoryViewController: UIViewController {

    
    var mainview: TMainViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initBackgroudMusic()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initDataBase(strtable: String) -> [AnyObject] {
        let databasemanager = TDatabaseManager.sharedInstance()
        
        var questions: [AnyObject]!
        
        if (databasemanager!.open("quiztroll.sqlite")) {
            
            //tb_dvhainaohoingu
            let strquery = "SELECT * FROM \(strtable)"
            questions = databasemanager?.loadData(fromDB: strquery) as! [AnyObject]
            
            databasemanager?.close()
        }
        
        return questions
    }
    
    func initBackgroudMusic() -> Void{
        let player = PlaySoundManager.shared
        player.prepareForSound()
        player.playSound(soundType: .Sound_Background)
    }

    @IBAction func back_Action(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            
        }
    }

    @IBAction func dovuihainao_Action(_ sender: AnyObject) {
    
        if (mainview == nil) {
            mainview = self.storyboard?.instantiateViewController(withIdentifier: "idmainview") as! TMainViewController
        }
        
        mainview.catequiz = CategoryQuiz.dovuihainao
        mainview.setupQuestions(question: initDataBase(strtable: "tb_dvhainaohoingu"))
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        PlaySoundManager.shared.stopPlaySound()

        self.present(mainview, animated: true) {
            
        }
    }

    @IBAction func dongthucvat_Action(_ sender: AnyObject) {
        
        if (mainview == nil) {
            mainview = self.storyboard?.instantiateViewController(withIdentifier: "idmainview") as! TMainViewController
        }
        
        mainview.catequiz = CategoryQuiz.dongthucvat
        mainview.setupQuestions(question: initDataBase(strtable: "tb_dvdongthucvat"))
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        PlaySoundManager.shared.stopPlaySound()
        
        self.present(mainview, animated: true) {
            
        }
        
    }
    
    @IBAction func diadanhlichsu_Action(_ sender: AnyObject) {
        
        
        if (mainview == nil) {
            mainview = self.storyboard?.instantiateViewController(withIdentifier: "idmainview") as! TMainViewController
        }
        
        mainview.catequiz = CategoryQuiz.diadanhlichsu
        mainview.setupQuestions(question: initDataBase(strtable: "tb_dvdiadanhlichsu"))
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        PlaySoundManager.shared.stopPlaySound()
        
        self.present(mainview, animated: true) {
            
        }
    }
    
    @IBAction func kienthucthandong_Action(_ sender: AnyObject) {
        
        if (mainview == nil) {
            mainview = self.storyboard?.instantiateViewController(withIdentifier: "idmainview") as! TMainViewController
        }
        
        mainview.catequiz = CategoryQuiz.kienthucthandong
        mainview.setupQuestions(question: initDataBase(strtable: "tb_dvkienthucthandong"))
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        PlaySoundManager.shared.stopPlaySound()
        
        self.present(mainview, animated: true) {
            
        }
        
    }
}
