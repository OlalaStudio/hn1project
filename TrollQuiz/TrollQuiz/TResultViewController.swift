//
//  TResultViewController.swift
//  Do
//
//  Created by NguyenThanhLuan on 20/07/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

import UIKit

protocol TResultViewDelegate {
    func didClickOnResultView();
}

class TResultViewController: UIViewController {

    var delegate: TResultViewDelegate!
    
    @IBOutlet weak var resultview: UIView!
    @IBOutlet weak var emoticon: UIImageView!
    @IBOutlet weak var flapicon: UIImageView!
    
    @IBOutlet weak var txtCaption: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    
    var strDescription: String = ""
    var user: String = ""
    var state: Bool = false
    
    let cryTip : [String] = ["Sai Rồi","Bó Tay","Haizz","Xem lại đi!","Sorry!!!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.init(red: 0.376, green: 0.376, blue: 0.384, alpha: 0.8)
        self.resultview.layer.cornerRadius = 8
        self.resultview.layer.shadowOpacity = 0.8
        self.resultview.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        
        var cryEmoticon: [UIImage] = [
            UIImage(named: "cry.png")!,
            UIImage(named: "cry1.png")!,
            UIImage(named: "cry2.png")!,
            UIImage(named: "cry3.png")!
        ]
        
        var flapEmoticon: [UIImage] = [
            UIImage(named: "lol.png")!,
            UIImage(named: "oach.png")!,
            UIImage(named: "omg.png")!,
            UIImage(named: "omg1.png")!,
            UIImage(named: "wtf.png")!
        ]
        
        let cryindex: NSInteger = NSInteger(arc4random_uniform(UInt32(cryEmoticon.count)))
        emoticon.image = cryEmoticon[cryindex]
        
        let flapindex = NSInteger(arc4random_uniform(UInt32(flapEmoticon.count)))
        flapicon.image = flapEmoticon[flapindex]
        
        txtDescription.text = strDescription
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnResultView(tap:)))
        self.view.addGestureRecognizer(tapgesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapOnResultView(tap: UITapGestureRecognizer) -> Void {
        if ((delegate != nil)) {
            delegate.didClickOnResultView()
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
    
    func setDescriptionString(description: String) -> Void {
        strDescription = description
    }
    
    func setUser(User: String) -> Void {
        user = User
    }
    
}
