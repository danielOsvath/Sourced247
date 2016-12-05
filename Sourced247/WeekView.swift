//
//  WeekView.swift
//  Sourced247
//
//  Created by Daniel Osvath on 5/26/16.
//  Copyright © 2016 Daniel Osvath. All rights reserved.
//

import UIKit
import Haneke

class WeekView: UICollectionViewController {
    
    var stories = [[NewsStory]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18.0)!]
        
        //adaptive layout for varous screen sizes. 
        if let cvl = collectionViewLayout as? UICollectionViewFlowLayout {
            let screenSize: CGRect = UIScreen.main.bounds
            let itemDims = getItemSize(screenSize)
            
            cvl.itemSize = itemDims
            cvl.sectionInset = getInsets(screenSize, itemDims: itemDims)
            cvl.minimumLineSpacing = screenSize.width * 0.05
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //load Data
        let tvbc = self.tabBarController as! DataTabBar
        self.stories = tvbc.stories
        
        
        if self.stories.isEmpty{
            addNetworkMessage()
        }else{
            self.collectionView?.backgroundView = UIView(frame: self.view.frame) //clear network message if present.
        }
        self.collectionView?.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNetworkMessage(){
        //error message when news cannot be downloaded.
        
        self.collectionView?.backgroundView = UIView(frame: self.view.frame)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.center = self.view.center
        label.textAlignment = NSTextAlignment.center
        
        label.textColor = UIColor.white
        label.text = "Could not load news. Please check network connection."
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        self.collectionView?.backgroundView?.addSubview(label)
    }

    func getInsets(_ screensize: CGRect, itemDims: CGSize) -> UIEdgeInsets{
        //get inset dimensions
        let screenWidth = screensize.width
        let itemwidth = itemDims.width
        
        let sides: CGFloat = (screenWidth - itemwidth*2)/3
        let topbottom: CGFloat = screenWidth * 0.05
        
        return UIEdgeInsets(top: topbottom, left: sides, bottom: topbottom , right: sides)
    }

    func getItemSize(_ screensize: CGRect) -> CGSize {
        //get dimensions for weekCell
        
        let maxwidth:CGFloat = 320.0
        let screenWidth = screensize.width
        
        var width = screenWidth * 0.4
        width = width > maxwidth ? maxwidth : width
        
        let height = width * 1.2

        return CGSize(width: width, height: height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "daySegue"{
            if let destination = segue.destination as? DayView{
                //                let index = tableView.indexPathForCell(sender as! UITableViewCell)!.row
                
                let index = (collectionView?.indexPath(for: sender as! UICollectionViewCell)! as NSIndexPath!).row
                let day = stories.count - index
                
                destination.currentDay = day
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of days to go back in news.
        if self.stories.count > 0{
            return 7
        }else{
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Week cells, get title and image.
        
        let cell: weekCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! weekCell
        
        let count = stories.count - 1 - (indexPath as NSIndexPath).row // start from end of array to show most recent day first.
        
        let daysDate = stories[count][0].date //NSDate of current day for cell
        
        cell.backgroundColor = UIColor.black
        cell.weekCell_Label.text = getDayNDate(daysDate as Date)
        cell.weekCell_Label.textAlignment = NSTextAlignment.center
        
        
        //get background image
        let url = URL(string: "http://sourcedweb.azurewebsites.net/backgrounds/" + String(count+1) + ".jpeg")!
        let format = Format<UIImage>(name: "background")
        cell.weekCell_Image.hnk_setImageFromURL(url, placeholder: nil, format: format, failure: nil, success: nil)
        
        return cell
    }
    
    func getDayNDate(_ date: Date) -> String{
        //get the day of news for the current cell. Return as string.
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        let monthNDate = formatter.string(from: date).characters.split{$0 == ","}.map(String.init)[0]
        
        formatter.dateStyle = DateFormatter.Style.full
        let weekDay = formatter.string(from: date).characters.split{$0 == ","}.map(String.init)[0]
        
        return weekDay + "\n" + monthNDate
    }
    
    func getWeekDay(_ date: Date) -> String{
        //get date helper function.
        
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: date)
        let weekDay = myComponents.weekday
        let days = [1:"Sunday",2:"Monday",3:"Tuesday",4:"Wednesday",5:"Thursday",6:"Friday",7:"Saturday"]
        
        return days[weekDay!]!
    }
    
}

