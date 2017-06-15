//
//  XPSearchViewController.swift
//  ixprez
//
//  Created by Quad on 5/29/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//



import UIKit

class XPSearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{
    
    @IBOutlet weak var publicTableView: UITableView!
     var getSearchURL = URLDirectory.Search()
    
    var recordPopularVideo = [[String:Any]]()
    
    var recordPublicVideo = [[String:Any]]()
    
    var recordisFiltered = [[String:Any]]()
    
    var getWebService = PrivateWebService()

    var actInd  = UIActivityIndicatorView()
    
    @IBOutlet var searchBar : UISearchBar!
    
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
     var isFiltered : Bool!
    var isFlag : Bool!
    
    var lastRecord : Bool!
    
    
    var Index = 0
    
    
    let imageView = UIImageView()
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     setBackGroundView()
        
        getPublicVideo()
        getPopularVideo()
        publicTableView.delegate = self
        publicTableView.dataSource = self
 
        actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge , color: .white, placeInTheCenterOf: self.publicTableView)
        
        
        actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .white, placeInTheCenterOf: self.searchCollectionView)
        
        
        actInd.startAnimating()
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
        
   isFiltered = false
    isFlag = false
    lastRecord = false
        
   
    }
    
    @IBAction func BackButtonAction (sender : Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func setBackGroundView()
    {
     
        
        imageView.frame = CGRect(x: self.publicTableView.frame.origin.x-160, y: self.publicTableView.frame.origin.y, width: self.publicTableView.frame.size.width, height: self.publicTableView.frame.size.height - 160)
        
        imageView.image = UIImage(named: "SearchCaughtUPBGImage")
        
        imageView.contentMode = .scaleAspectFit
        
    }
 
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
           self.publicTableView.endEditing(true)
    }
    
    
    func getPublicVideo()
    {
        
      
        Index += 1
        
 
        let dicData = ["user_email":"mathan6@gmail.com","emotion":"like","index":Index,"limit":30,"language":"English (India)","country":"IN"] as [String : Any]
        
        
        getWebService.getPrivateDataWebService(urlString: getSearchURL.publicVideo(), dicData: dicData as NSDictionary, callback:  { (dic,myData, err ) in
            
            
            
            if (myData["last"] as! Int == 0)
            {

    
            for dicData in dic
            {
             self.recordPublicVideo.append(dicData)
             self.recordisFiltered.append(dicData)
          
             }
        
            }
            
            else
            {
                print("Last Record")
                self.lastRecord = true
            }
            
            
            DispatchQueue.main.async {
                
                self.publicTableView.reloadData()
                
            }
            
        
        })
        
        
    }
    
    func   getPopularVideo()
    {
        let dicData = ["user_email": "mathan6@gmail.com"]
        
        getWebService.getPrivateDataWebService(urlString: getSearchURL.searchPopularVideo() , dicData: dicData as NSDictionary, callback: {(dicc, myData, err) in
          
            if ( err == nil)
            {
            self.recordPopularVideo = dicc
                
                print ( "Popular Video", self.recordPopularVideo)
                
                
                DispatchQueue.main.async
                    {
                        self.actInd.stopAnimating()
                        self.searchCollectionView.reloadData()
               
                }
             
            }
            else
            {
                DispatchQueue.main.async {
                    self.actInd.startAnimating()
                }
            }
            
        })
     
    }
//getPrivateDataWebService
    
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
     {
        
        
      
        if searchText.characters.count == 0
        {
           isFiltered = false
            DispatchQueue.main.async {
                
                self.publicTableView.reloadData()
                
            }
          }
            else
              {

            isFiltered = true
            
            recordisFiltered = recordPublicVideo.filter({
                
                var string = $0["title"] as! String
                
                print(string)
                
                
                string = string.lowercased()
                
             if recordisFiltered.count == 0
             {
                isFiltered = false
                
                print("hai nil")
                
              }
                else
                {
                isFiltered = true
                
                print("data here")
              
               //return string.lowercased().range(of: searchText.lowercased() ) != nil
             
                }
               
                return string.lowercased().range(of: searchText.lowercased() ) != nil
           
            })
                
                DispatchQueue.main.async {
                    
                    self.publicTableView.reloadData()
                    
                }
       }
        
        print("mathan search",recordisFiltered)
        
    
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        
        
         searchBar.resignFirstResponder()
        
        return true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if isFiltered == true
        {
            if lastRecord == false
            {
            
            return recordisFiltered.count + 1
            }
            else
            {
               return recordisFiltered.count 
            }
        }
        else
        {
            if lastRecord == false
            {
                
                return recordPublicVideo.count + 1
            }
            else
            {
               return recordPublicVideo.count
            }
     
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "publiccell") as! XPPublicDataTableViewCell
        
        cell.imgAudioVideo.layer.borderWidth = 0.5
        
        cell.imgAudioVideo.layer.borderColor = UIColor.lightGray.cgColor
        
        
         cell.imgAudioVideo.clipsToBounds = true
        
         cell.isHidden = true
        
        
      if isFiltered == false
      {
        
        if indexPath.row < recordPublicVideo.count
        {
            
            
            publicTableView.backgroundView?.isHidden = false
            
            
            publicTableView.backgroundView = imageView
            
        
        /*let publicData = recordPublicVideo[indexPath.row]
        
        cell.lblTitle.text = publicData["title"] as? String
        
       //cell.lblSubTitle.text = publicData["tags"] as? String
        
        cell.lblReactionCount.text = String(format: "%d  Reactions", publicData["emotionCount"] as! Int)
        
       cell.lblLikeCount.text = String(format: "%d  Likes", publicData["likeCount"] as! Int)
     
       cell.lblViewCount.text = String(format: "%d  Views", publicData["viewed"] as! Int)
       
        cell.btnPlayPublicVideo.tag = indexPath.row

     
        
        cell.btnPlayPublicVideo.addTarget(self, action: #selector(playPublicVideo(sender:)), for: .touchUpInside)
        
        //filemimeType
        
        
    if  (publicData["filemimeType"] as! String) == "video/mp4"
        {
        cell.imgVA.image = UIImage(named: "SearchVideoOff")
        
        }
        else
        {
           cell.imgVA.image = UIImage(named: "privateAudio")
        }
    
        var thumbString = publicData["thumbnailPath"] as! String
            
       thumbString.replace("/root/cpanel3-skel/public_html/Xpress/",with: "http://103.235.104.118:3000/")
        
        
        print("mathan check thumString",thumbString)
      
        cell.imgAudioVideo.getImageFromUrl(thumbString)*/
            
            
            return cell
            
        }
        
        
        else
       {
            
           getPublicVideo()
            
           return cell
        }
        
        
        
        
        
        }
        
        else
      {
        
        cell.isHidden = false
        
        publicTableView.backgroundView?.isHidden = true
        
        
        if indexPath.row < recordisFiltered.count
        {
        
        
         let publicData = recordisFiltered[indexPath.row]
        
        cell.lblTitle.text? = (publicData["title"] as? String)!.capitalized
           
            
        cell.lblReactionCount.text = String(format: "%d  Likes", publicData["emotionCount"] as! Int)
        
        
        cell.lblLikeCount.text = String(format: "%d  Likes", publicData["likeCount"] as! Int)
        
        cell.lblViewCount.text = String(format: "%d  Views", publicData["viewed"] as! Int)
        
        cell.btnPlayPublicVideo.tag = indexPath.row
        
        cell.btnPlayPublicVideo.addTarget(self, action: #selector(playPublicVideo(sender:)), for: .touchUpInside)
        
        
        if  (publicData["filemimeType"] as! String) == "video/mp4"
        {
            cell.imgVA.image = UIImage(named: "SearchVideoOn")
            
            isFlag = true
            
        }
        else
        {
            cell.imgVA.image = UIImage(named: "privateAudio")
        }
      
         var thumbString = publicData["thumbnailPath"] as! String
         
         thumbString.replace("/root/cpanel3-skel/public_html/Xpress/",with: "http://103.235.104.118:3000/")
         
         
         
         print("mathan check thumString",thumbString)
         
         cell.imgAudioVideo.getImageFromUrl(thumbString)
        
        
       // cell.imgAudioVideo.image = UIImage(named: "good.jpg")
        
      
        
        
        print("mathan ma",indexPath.row)
        
        return cell

        }
         else
         {
            
           
        getPublicVideo()
         
        }
       
        }

       return cell
    }
    
    
  func playPublicVideo(sender: UIButton)
    {
        if isFiltered == false
        {
        
       /* let indexPathValue = IndexPath(row: sender.tag, section: 0)
        
       // let cell = self.publicTableView.cellForRow(at: indexPathValue) as! XPPublicDataTableViewCell
    
    
        
        let publicData = recordPublicVideo[indexPathValue.row]
        
        let playTitle = publicData["title"] as! String
        
        var playVideoPath = publicData["fileuploadPath"] as! String
        
        playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        let playFilemimeType = publicData["filemimeType"] as! String
        
        let playID = publicData["_id"] as! String
        
        let playLikeCount = publicData["likeCount"] as! Int
        
        let playViewCount = publicData["viewed"] as! Int
        
        let playSmiley = publicData["emotionCount"] as! Int
    
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
    
        playViewController.playTitle = playTitle
        
        playViewController.playUrlString = playVideoPath
        
        playViewController.playLike = playLikeCount
        
        playViewController.playView = playViewCount
        
        playViewController.playSmiley = playSmiley
        
        playViewController.nextFileType = playFilemimeType
        
        playViewController.nextID = playID
        
        self.navigationController?.pushViewController(playViewController, animated: true)*/
            
   
        }
        else
        {
            let indexPathValue = IndexPath(row: sender.tag, section: 0)

            
            let publicData = recordisFiltered[indexPathValue.row ]
            
            
            let playTitle = publicData["title"] as! String
            
            var playVideoPath = publicData["fileuploadPath"] as! String
            
            playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
            
            let playFilemimeType = publicData["filemimeType"] as! String
            
            let playID = publicData["_id"] as! String
            
            let playLikeCount = publicData["likeCount"] as! Int
            
            let playViewCount = publicData["viewed"] as! Int
            
            let playSmiley = publicData["emotionCount"] as! Int
            
            let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
            
            playViewController.playTitle = playTitle
            
            playViewController.playUrlString = playVideoPath
            
            playViewController.playLike = playLikeCount
            
            playViewController.playView = playViewCount
            
            playViewController.playSmiley = playSmiley
            
            playViewController.nextFileType = playFilemimeType
            
            playViewController.nextID = playID
            
            self.navigationController?.pushViewController(playViewController, animated: true)
        }
        
    
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell") as! XPSearchTableViewCell
 
        
        cell.publicSearch.delegate = self
        
        return cell.contentView
   
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat

    {
        
        return 50
        
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
        
        
        
        //createdAt
        
       let dateInfo = popularData["createdAt"] as! String
        
        
        let dataStringFormatter = DateFormatter()
        
        dataStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date1 = dataStringFormatter.date(from: dateInfo)
        
        
        let date2 = Date()
        
        
        let calender = NSCalendar.current
        
        let myDate1 = calender.startOfDay(for: date1!)
        
        let myDate2 = calender.startOfDay(for: date2)
        
        
        let components = calender.dateComponents([.day], from: myDate1, to: myDate2)
        
        
        cell.lblPopularDay.text = String(format: "%d Day ago", components.day!)
        
        
        cell.imgPopularPhoto.image = nil
        
      
        print(popularData["filemimeType"] as! String)
        
        if ( popularData["thumbnailPath"] as? String != nil )
        {
            
 
            var orginalStringUrl = popularData["thumbnailPath"] as! String
            
            orginalStringUrl.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")

            print("Check Image URL video  ",orginalStringUrl)
            cell.imgPopularPhoto.getImageFromUrl(orginalStringUrl)
        }
        
      else
        {
            
            
            cell.imgPopularPhoto.backgroundColor = UIColor.getPrivateCellColor()
            
            
        }
        
        
        
        cell.btnPlayPopularVideo.tag = indexPath.item
        
        
        cell.btnPlayPopularVideo.addTarget(self, action: #selector(playPopularVideo(sender:)), for: .touchUpInside)
        
        
      return cell
        
        
    }
    
    func playPopularVideo(sender : UIButton)
    {
        
        let indexPathValue = IndexPath(item: sender.tag, section: 0)
        
        let popularData = recordPopularVideo[indexPathValue.item]
        
        let playTitle = popularData["title"] as! String
        
        var playVideoPath = popularData["fileuploadPath"] as! String
        
        playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        let playFilemimeType = popularData["filemimeType"] as! String
        
        let playID = popularData["_id"] as! String
        
        let playLikeCount = popularData["likeCount"] as! Int
        
        let playViewCount = popularData["viewed"] as! Int
        
        let playSmiley = popularData["emotionCount"] as! Int
        
        
        
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        
        
        playViewController.playTitle = playTitle
        
        playViewController.playUrlString = playVideoPath
        
        playViewController.playLike = playLikeCount
        
        playViewController.playView = playViewCount
        
        playViewController.playSmiley = playSmiley
        
        playViewController.nextFileType = playFilemimeType
        
        playViewController.nextID = playID
        
        
     self.navigationController?.pushViewController(playViewController, animated: true)
        
        
    }
 
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
      let cellWidth = self.searchCollectionView.frame.size.width/2 - 30
        
        let cellHight = self.searchCollectionView.frame.size.height - 30
        
        
        
      var returnCell = CGSize(width: cellWidth, height: cellHight)
        
        
        returnCell.width += 13
        
       // returnCell.height += 15
        
        
        return returnCell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat

    {
       return 10.0
    }
 

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
       return 10.0
        
    }
    
   
    
 func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
 {
    
    UIView.animate(withDuration: 0.5, delay: 1.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut , animations: {
        
        
        searchBar.showsCancelButton = true
        
        self.collectionViewWidth.constant -= 160
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }, completion: nil)
    
 
    
    
    return true
    
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        
        self.navigationController?.navigationBar.isHidden = false

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.navigationController?.navigationBar.isHidden = false
        collectionViewWidth.constant = 160
        searchBar.resignFirstResponder()
         searchBar.showsCancelButton = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        isFiltered = false
        searchBar.text = nil
        self.navigationController?.navigationBar.isHidden = false
        collectionViewWidth.constant = 160
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        DispatchQueue.main.async {
            
            self.publicTableView.reloadData()
            
            
        }
        
    }
    
 
/*
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        
        
        if (Index <= 4)
        {
            print("mathan indexPath.row", indexPath.row)
          
            getPublicVideo()
            
            
        }
        
    }
 
 */
    
}


