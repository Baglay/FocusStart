//
//  ImageViewController.swift
//  FocusStartIOS
//
//  Created by Родион Баглай on 23.01.17.
//  Copyright © 2017 Родион Баглай. All rights reserved.
//


import UIKit

class ImageViewController: UIViewController {
    
    var imageLink : String? 
    var cache = NSCache<AnyObject, AnyObject>()
    
   
  
    
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
     
    @IBAction func closePopUp(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
               
        if let img = cache.object(forKey: imageLink as AnyObject) {
            image.image = img as? UIImage
        }
        else {
            DispatchQueue.global().async {
               let data = NSData(contentsOf: (URL(string: (self.imageLink!)))!)
               
                DispatchQueue.main.async {
                    
                    self.image.image = UIImage(data: data as! Data)
                    self.cache.setObject(UIImage(data: data as! Data)!, forKey: self.imageLink as AnyObject)
               
                        self.closeBtn.reloadInputViews()
                    
                }
               
            }
        }
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
