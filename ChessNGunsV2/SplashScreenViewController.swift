//
//  SplashScreenViewController.swift
//  ChessNGunsV2
//
//  Created by Aditya Dwivedi on 12/1/16.
//  Copyright © 2016 org.cuappdev.project. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    var label: UILabel!
    
    override func viewDidLoad() {
        super.view.backgroundColor = UIColor(patternImage: UIImage(named: "patternOpener")!)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.75, height: view.frame.height*0.125))
        label.text = "DistractCHESS"
        label.textColor = .gray
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "AmericanTypeWriter-Bold", size: 45)
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
        label.center = view.center
        label.backgroundColor = UIColor(white: 1, alpha: 0)
        view.addSubview(label)
        
        let newGameButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.35, height: view.frame.height*0.075))
        newGameButton.center.x = view.center.x
        newGameButton.center.y = view.center.y*1.05
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        newGameButton.setTitleColor(UIColor.blue.withAlphaComponent(0.8), for: .normal)
        newGameButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        
        let aboutButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.35, height: view.frame.height*0.075))
        aboutButton.center.x = view.center.x
        aboutButton.center.y = view.center.y*1.25
        aboutButton.setTitle("About", for: .normal)
        aboutButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        aboutButton.setTitleColor(UIColor.purple.withAlphaComponent(0.8), for: .normal)
        aboutButton.addTarget(self, action: #selector(aboutButtonPressed), for: .touchUpInside)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        UIView.animate(withDuration: 1, animations: {
            self.label.center.y = self.view.center.y * 0.45
        }, completion: { _ in
            self.view.addSubview(newGameButton)
            self.view.addSubview(aboutButton)
        })
       
    }
    
    func newGame() {
         self.navigationController?.pushViewController(GameGridViewController(), animated: true)
    }
    
    func aboutButtonPressed() {
        navigationController?.pushViewController(AboutViewController(), animated: true)
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

}
