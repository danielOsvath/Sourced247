//
//  LinksView.swift
//  Sourced 247
//
//  Created by Daniel Osvath on 7/4/16.
//  Copyright © 2016 Daniel Osvath. All rights reserved.
//

import UIKit

class LinksView: UITableViewController {
    
    var links: String = ""
    var sources: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18.0)!]
        
        //trim and split links.
        self.sources = links.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ", ")
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath)
        
        cell.textLabel?.text = sources[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //cell height
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webSegue"{
            if let destination = segue.destination as? WebpageView{
                let index = (tableView.indexPath(for: sender as! UITableViewCell)! as NSIndexPath).row
                
                destination.url = URL(string: sources[index])!
            }
        }
    }
}
