//
//  TableViewController.swift
//  FocusStartIOS
//
//  Created by Родион Баглай on 23.01.17.
//  Copyright © 2017 Родион Баглай. All rights reserved.
//


import UIKit

class TableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    
    var messages = [Messages]()
    var imageSource = [String]()
    var imageData: NSData?
    var imageSourceData = [String]()
    
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getMessagesFile()
        sortMessage()
       
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func sortMessage() {
        
        messages.sort { (first, second) -> Bool in
            return first.date! > second.date!
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if self.messages[indexPath.row].type == "social" {
            
            let url1 = messages[indexPath.row].source
            UIApplication.shared.openURL(URL(string: url1!)!)
            tableView.deselectRow(at:indexPath, animated: true)
            
                   }
        
        if self.messages[indexPath.row].type == "image" {
            
            let image = messages[indexPath.row].source
            performSegue(withIdentifier: "image", sender: image)
             tableView.deselectRow(at:indexPath, animated: true)

        }
        
        if self.messages[indexPath.row].type == "text" {
             tableView.deselectRow(at:indexPath, animated: true)
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        if  segue.identifier == "image" {
            
            let destVC = segue.destination as! ImageViewController
            destVC.imageLink = sender as? String

        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        
        cell.labelOne.text = self.messages[indexPath.row].date
        cell.labelTitle.text = self.messages[indexPath.row].title
        cell.labelContent.text = self.messages[indexPath.row].content
        cell.imageSource.image = nil
        
        
        
        
        if self.messages[indexPath.row].type == "text" {
            
            cell.labelTitle.text = self.messages[indexPath.row].title
            cell.labelOne.text = self.messages[indexPath.row].date
            cell.labelContent.text = messages[indexPath.row].content
            //tableView.deselectRow(at: indexPath, animated: false)
            
        }
            
        else if self.messages[indexPath.row].type == "social"  && self.messages[indexPath.row].network != nil{
            
           
            
            
            if self.messages[indexPath.row].network == "facebook" {
                
                cell.imageSource.image = UIImage(named: "facebook")
                cell.labelTitle.text = self.messages[indexPath.row].title
                cell.labelOne.text = self.messages[indexPath.row].date
                cell.labelContent.text = messages[indexPath.row].content
                
                
                
            }
                
            else if self.self.messages[indexPath.row].network == "twitter" {
                cell.imageSource.image = UIImage(named: "twitter")
                cell.labelTitle.text = self.messages[indexPath.row].title
                cell.labelOne.text = self.messages[indexPath.row].date
                cell.labelContent.text = messages[indexPath.row].content
                
                
            }
                
            else if self.messages[indexPath.row].network == "vkontakte" {
                cell.imageSource.image = UIImage(named: "vkontakte")
                cell.labelTitle.text = self.messages[indexPath.row].title
                cell.labelOne.text = self.messages[indexPath.row].date
                cell.labelContent.text = messages[indexPath.row].content
                
                
            }
            
            
        }
            
            
            
            
        else if  self.messages[indexPath.row].type == "image" {
            
            
            if let img = cache.object(forKey: messages[indexPath.row].source as AnyObject) {
                cell.imageSource.image = img as? UIImage
            }
            else {
                DispatchQueue.global().async {
                    let data = NSData(contentsOf: URL(string: self.messages[indexPath.row].source!)!)
                    DispatchQueue.main.async {
                        cell.imageSource.image = UIImage(data: data as! Data)
                        self.cache.setObject(UIImage(data: data as! Data)!, forKey:self.messages[indexPath.row].source as AnyObject)
                        tableView.reloadData()
                        
                    }
                }
            }
            
        }
        
        return cell
        
    }
    
    
    
    
    func getMessagesFile() -> [Messages] {
        
        let bundle = Bundle(for: type(of: self))
        if let theURL = bundle.url(forResource: "messages", withExtension: "json") {
            do {
                let data = try Data(contentsOf: theURL)
                if let jsonResult = try? JSONSerialization.jsonObject(with: data)
                {
                    
                    let jsonMessages = jsonResult as? [AnyObject]
                    
                    for jsonMessage in jsonMessages! {
                        
                        let message = Messages()
                        
                        message.type    = jsonMessage["type"] as? String
                        message.date    = jsonMessage["date"] as? String
                        message.title   = jsonMessage["title"] as? String
                        message.content = jsonMessage["content"] as? String
                        message.network = jsonMessage["network"] as? String
                        message.source  = jsonMessage["source"] as? String
                        self.messages.append(message)
                        
                    }
                    
                }
            } catch {
                print(error)
            }
        }
        
        return messages
    }
}





/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 
 
 /*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */
 
 /*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */
 
 /*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */
 
 
}*/
