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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dovuihainao_Action(_ sender: AnyObject) {
    
        if (mainview == nil) {
            mainview = self.storyboard?.instantiateViewController(withIdentifier: "idmainview") as! TMainViewController
        }
        
        mainview.catequiz = CategoryQuiz.dovuihainao
        
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
        
        PlaySoundManager.shared.playSound(soundType: .Sound_BtnTap)
        PlaySoundManager.shared.stopPlaySound()
        
        self.present(mainview, animated: true) {
            
        }
        
    }
}
