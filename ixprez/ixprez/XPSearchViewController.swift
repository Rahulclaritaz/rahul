//
//  XPSearchViewController.swift
//  ixprez
//
//  Created by Quad on 5/29/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPSearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
 var getSearchURL = URLDirectory.Search()
    
    var recordPopularVideo = [[String:Any]]()
    
    
 var getWebService = PrivateWebService()
    
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPopularVideo()

        // Do any additional setup after loading the view.
    }
    
    func   getPopularVideo()
    {
        let dicData = ["user_email": "jnjaga24@gmail.com"]
        
        getWebService.getPrivateDataWebService(urlString: getSearchURL.searchPopularVideo() , dicData: dicData as NSDictionary, callback: {(dicc, err) in
          
            if ( err == nil)
            {
            self.recordPopularVideo = dicc
                
                DispatchQueue.main.async
                    {
                        self.searchCollectionView.reloadData()
               
                }
             
            }
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
{
    return self.recordPopularVideo.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
     
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! XPSearchPopularCollectionViewCell
        
      cell.layer.cornerRadius = 5.0
        
      cell.layer.borderWidth = 1.0
        
      cell.layer.borderColor = UIColor.clear.cgColor
        
      let popularData = recordPopularVideo[indexPath.item]
        
      cell.lblPopularTitle.text = popularData["title"] as? String
        
      cell.lblPopularLike.text =  String(format: "%d Likes", arguments: [popularData["likeCount"] as! Int])
        
      cell.lblPopularEmotion.text = String(format: "%d Reactions", arguments: [popularData["emotionCount"] as! Int])
        
      cell.lblPopularViews.text = String(format: "%d Views", popularData["viewed"] as! Int)
        
       cell.lblPopularDay.text = "1 Day ago"
    
        
        cell.imgPopularPhoto.image = nil
        
      
        print(popularData["filemimeType"] as! String)
        
        if (  (popularData["filemimeType"] as! String) == "video/mp4" )
        {
            var orginalStringUrl = popularData["thumbnailPath"] as! String
            
            orginalStringUrl.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")

            print(orginalStringUrl)
            cell.imgPopularPhoto.getImageFromUrl(orginalStringUrl)
        }
        
        else
        {
            cell.imgPopularPhoto.backgroundColor = UIColor.getPrivateCellColor()
            
            
        }
        
        
      return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
      let cellWidth = self.searchCollectionView.frame.size.width/2 - 20
        
        let cellHight = self.searchCollectionView.frame.size.height - 20
        
        
        
      var returnCell = CGSize(width: cellWidth, height: cellHight)
        
        
        returnCell.width += 5
        
        return returnCell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
    }
    

}
