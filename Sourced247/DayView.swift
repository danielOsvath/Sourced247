//
//  DayView.swift
//  Sourced247
//
//  Created by Daniel Osvath on 5/26/16.
//  Copyright © 2016 Daniel Osvath. All rights reserved.
//

import UIKit
import Haneke

class DayView: UITableViewController {
    
    var currentDay = 6
    var stories = [[NewsStory]]()
    var dayStories = [NewsStory]()
    var status = "Loading"
    //counter 
    //clicked stories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18.0)!]
        
        NotificationCenter.default.addObserver(self, selector: #selector(DayView.becameActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.separatorColor = UIColor.clear
        
        becameActive()
    }
    
    func becameActive(){
        
        loadBackground()
        
        getNewsData()
        
    }
    
    func getNewsData(){
        
        self.stories = []
        self.dayStories = []
        
        let dataURL = URL(string: "http://sourcedweb.azurewebsites.net/appdata.php")!
        let c = Haneke.Shared.JSONCache
        c.removeAll()
        
        c.fetch(URL: dataURL).onSuccess{ json in
            
            let mdata = json.asData()
            let myJSON = JSON(data: mdata!).arrayValue
            
            print(myJSON)
            
            self.populateStoriesObject(myJSON)
            self.dayStories = self.stories[self.currentDay-1]
            
            self.tableView.separatorColor = UIColor.lightGray
            self.tableView.reloadData()
            
            
            if let tvbc = self.tabBarController as? DataTabBar {
                tvbc.stories = self.stories
            }
            
            
            }.onFailure{error in
                
                self.tableView.reloadData()
                if self.stories.isEmpty{
                    self.addNetworkMessage()
                    
                    if let tvbc = self.tabBarController as? DataTabBar {
                        tvbc.stories = self.stories
                    }
                }
        }

    }
    
    func addNetworkMessage(){
        
        for view in (self.tableView.backgroundView?.subviews)!{
            //make sure multiple messages are not added
            view.removeFromSuperview()
        }
        
        //error message when news cannot be downloaded.
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.center = self.view.center
        label.textAlignment = NSTextAlignment.center
        
        label.textColor = UIColor.white
        label.text = "Could not load news. Please check network connection."
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        self.tableView.backgroundView?.addSubview(label)
    }
    
    func populateStoriesObject(_ myJSON: [JSON]){
        // get data from JSON and place into 2D array of NewsStory objects.
        
        for news in myJSON{
            
            let newid = Int(news["id"].stringValue)!
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            
            let newdate = dateformatter.date(from: news["date"].stringValue)!
            let newSubtitle = news["subtitle"].stringValue
            let newheadline = news["headline"].stringValue
            let newlinks = news["links"].stringValue
            let newday = Int(news["day"].stringValue)!
            let newclicks = Int(news["clicks"].stringValue)!
            
            let story = NewsStory(id: newid, date: newdate, headline: newheadline, subtitle: newSubtitle, links: newlinks, day: newday, clicks: newclicks)
            
            if self.stories.count < newday{
                self.stories.append([story])
            }else{
                self.stories[newday-1].append(story)
            }
        }
        
    }
    
    func loadBackground(){
        //get image from URL for the current day in the day view..
        let url = URL(string: "http://sourcedweb.azurewebsites.net/backgrounds/" + String(self.currentDay) + ".jpeg")
        
        let imageView = UIImageView(frame: self.view.frame)
        let format = Format<UIImage>(name: "background")
        imageView.hnk_setImageFromURL(url!, placeholder: nil, format: format, failure: nil, success: nil)
        
        self.tableView.backgroundView = imageView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayStories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        
        cell.textLabel?.text = dayStories[(indexPath as NSIndexPath).row].headline
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
      
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //cell height
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if dayStories.count > 0{
            return 1
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = dayStories[0].date  // get date for day (from first story)
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let currentDay = formatter.string(from: date as Date)
        
        return currentDay
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        
        /* Create Blur effect */
        let blureffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blureffect)
        blurredEffectView.frame = (header.backgroundView?.bounds)!
        
        for view in (header.backgroundView?.subviews)! {
            //remove subviews because it would add extra on entering foreground.
            view.removeFromSuperview()
        }
        
        header.backgroundView?.addSubview(blurredEffectView)

        header.backgroundView?.backgroundColor = UIColor.clear
        header.backgroundView?.alpha = 0.9
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "linkSegue"{
            if let destination = segue.destination as? LinksView{
                let index = (tableView.indexPath(for: sender as! UITableViewCell)! as NSIndexPath).row

                destination.links = dayStories[index].links
            }
        }
    }
    
}

