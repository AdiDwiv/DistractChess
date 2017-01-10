//
//  AboutViewController.swift
//  ChessNGunsV2
//
//  Created by Aditya Dwivedi on 12/1/16.
//  Copyright © 2016 org.cuappdev.project. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let about = UITextView(frame: CGRect(x: 5, y: 20, width: view.frame.width, height: view.frame.height))
        about.text = "Developed by Aditya Dwivedi \nImages and patterns from www.colourlovers.com\nSounds from www.freesound.org\nFor attributions and individual credit check Readme at www.github.com/AdiDwiv/DistractChess"
        view.addSubview(about)
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

}
