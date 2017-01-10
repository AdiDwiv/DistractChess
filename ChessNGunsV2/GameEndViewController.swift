//
//  GameEndViewController.swift
//  ChessNGunsV2
//
//  Created by Aditya Dwivedi on 11/30/16.
//  Copyright © 2016 org.cuappdev.project. All rights reserved.
//

import UIKit

class GameEndViewController: UIViewController {
    
    var whoWon: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "patternOpener")!)

        let label = UILabel(frame: CGRect(x: 200, y: view.frame.height*0.125, width: view.frame.width*0.75, height: view.frame.height*0.125))
        label.text = whoWon+" wins"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
        label.center.x = view.center.x
        label.backgroundColor = UIColor(white: 1, alpha: 0)
        
        view.addSubview(label)
        
        let playButton = UIButton(frame: CGRect(x: 0, y: view.frame.height*0.5, width: view.frame.width*0.45, height: view.frame.width*0.15))
        playButton.center.x = view.center.x
        playButton.setTitle("Return to main menu", for: .normal)
        playButton.setTitleColor(UIColor.blue, for: .normal)
        playButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        playButton.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.addSubview(playButton)
        
        let aboutButton = UIButton(frame: CGRect(x: 0, y: view.frame.height*0.65, width: view.frame.width*0.25, height: view.frame.width*0.15))
        aboutButton.center.x = view.center.x
        aboutButton.setTitle("About", for: .normal)
        aboutButton.setTitleColor(UIColor.purple, for: .normal)
        aboutButton.addTarget(self, action: #selector(button2Pressed), for: .touchUpInside)
        aboutButton.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.addSubview(aboutButton)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func buttonPressed() {
        let allViewControllers = navigationController!.viewControllers as [UIViewController]
        navigationController?.popToViewController(allViewControllers[allViewControllers.count - 3], animated: true)
    }
    
    func button2Pressed() {
        navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    func setString(winner: Int) {
        if winner == 1 {
            whoWon = "White"
            return
        }
        whoWon = "Black"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }/Users/Adi/Desktop/white.png
    */

}
