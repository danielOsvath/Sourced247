//
//  DataTabBar.swift
//  Sourced 247
//
//  Created by Daniel Osvath on 7/3/16.
//  Copyright © 2016 Daniel Osvath. All rights reserved.
//

import UIKit
import Haneke

class DataTabBar: UITabBarController {
    
    var stories = [[NewsStory]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews(){
        //Set up logos in navigation bar
        
        let Logo = UIImage(named: "SourcedLogoNavbarWhite")
        let LogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 48))
        LogoView.contentMode = .scaleAspectFit
        LogoView.image = Logo
        
        self.navigationItem.titleView = LogoView
        
        self.tabBar.itemPositioning = UITabBarItemPositioning.fill
    }
    
  }
