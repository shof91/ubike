//
//  meunViewController.swift
//  ubike
//
//  Created by sho on 2023/10/7.
//

import Foundation
import UIKit

class menuViewController: UIViewController, UINavigationControllerDelegate{
    private let loginButton = UIButton()
  
    @IBOutlet weak var bnt1: UIButton!
    @IBOutlet weak var bnt2: UIButton!
    @IBOutlet weak var bnt3: UIButton!
    @IBOutlet weak var bnt4: UIButton!
    @IBOutlet weak var bnt5: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    private let menuItems = ["使用說明", "收費方式", "站點資訊", "最新消息", "活動專區"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        bntAllWhite()
        
        let score = 2
        switch score {
        case 0:
            bnt1.titleLabel?.textColor = .lightGray
        case 1:
            bnt2.titleLabel?.textColor = .lightGray
        case 2:
            bnt3.titleLabel?.textColor = .lightGray
        case 3:
            bnt4.titleLabel?.textColor = .lightGray
        case 4:
            bnt5.titleLabel?.textColor = .lightGray
        default:
            bnt3.titleLabel?.textColor = .lightGray
        }
        
        
        loginBtn.backgroundColor = .white
        
        loginBtn.clipsToBounds = true;
        loginBtn.layer.cornerRadius = 15;
        self.view.frame = CGRect(x: 0, y: 85, width: Int(self.view.frame.width), height:Int(self.view.frame.width-85))

        navigationItem.title = ""
        let BarItem = UIBarButtonItem(image: UIImage(named: "del")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItem = BarItem
        
        let imgBarItem = UIBarButtonItem(image: UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = imgBarItem
       
 
    }

    @IBAction func bnt1Down(_ sender: Any) {
        bntAllWhite()
        
    }
    @IBAction func bnt2Down(_ sender: Any) {
        bntAllWhite()
       
    }
    @IBAction func bnt3Down(_ sender: Any) {
        bntAllWhite()
        let myStoryBoard = UIStoryboard(name:"Main", bundle: nil)
        
              
        let targetController = myStoryBoard.instantiateViewController(withIdentifier: "ViewController")
        targetController.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(targetController, animated: true)
    }
    @IBAction func bnt4Down(_ sender: Any) {
        bntAllWhite()
        
        
    }
    @IBAction func bnt5Down(_ sender: Any) {
        bntAllWhite()
        
    }
    @IBAction func loginfuc(_ sender: Any) {
    }
    func bntAllWhite(){
        bnt1.titleLabel?.textColor = .white
        bnt2.titleLabel?.textColor = .white
        bnt3.titleLabel?.textColor = .white
        bnt4.titleLabel?.textColor = .white
        bnt5.titleLabel?.textColor = .white
    }
    @objc func menuButtonTapped() {
        // Handle left menu button tap
       
        self.navigationController?.popViewController(animated: true)
    }
}
