//
//  WebpageView.swift
//  Sourced 247
//
//  Created by Daniel Osvath on 7/4/16.
//  Copyright © 2016 Daniel Osvath. All rights reserved.
//

import UIKit

class WebpageView: UIViewController{
    
    var url = URL(string: "")
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        
         self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18.0)!]
        
        
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
        
    }
    
    override func didReceiveMemoryWarning() {
        
        
    }
}
