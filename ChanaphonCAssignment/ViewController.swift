//
//  ViewController.swift
//  ChanaphonCAssignment
//
//  Created by Digital-MacbookPro on 4/17/2560 BE.
//  Copyright © 2560 i2t.co.th. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    final let URL1String = "http://www.anop72.info/api/seed.json"
    var coverURLArray = [String]()
    var nameArray = [String]()
    var typeArray = [String]()
    @IBOutlet weak var playlist1UITableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadJSONWithURL()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: JSON method
  func downloadJSONWithURL(){
    //print("test1 passed")
        let url = NSURL(string: URL1String)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let JSONObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray{
                //print(JSONObj)
                guard let mediaArray = JSONObj! as? NSArray else {
                    fatalError("unable to create mediaArray")
                }
                for media in mediaArray{
                    if let mediaDict = media as? NSDictionary{
                        if let cover = mediaDict.value(forKey: "cover"){
                            //print(mediaDict.value(forKey: "cover"))
                            self.coverURLArray.append(cover as! String)
                            //print(self.coverURLArray)
                        }
                        if let cover = mediaDict.value(forKey: "name"){
                            self.nameArray.append(cover as! String)
                        }
                        if let cover = mediaDict.value(forKey: "type"){
                            self.typeArray.append(cover as! String)
                            //print(self.typeArray)
                        }
                    }
                }
                
                
//                if let mediaArray = JSONObj! as? NSArray{
//                    //self.coverURLArray.append(JSONObj!.value(forKey: "cover"))
//                    //print(mediaArray)
//                    for media in mediaArray{
//                        if let mediaDict = media as? NSDictionary{
//                            if let cover = mediaDict.value(forKey: "cover"){
//                                //print(mediaDict.value(forKey: "cover"))
//                                self.coverURLArray.append(cover as! String)
//                                //print(self.coverURLArray)
//                            }
//                            if let cover = mediaDict.value(forKey: "name"){
//                                self.nameArray.append(cover as! String)
//                            }
//                            if let cover = mediaDict.value(forKey: "type"){
//                                self.typeArray.append(cover as! String)
//                                //print(self.typeArray)
//                            }
//                            
//                            
//                        }
//                    }
//                }
                OperationQueue.main.addOperation({
                    self.playlist1UITableView.reloadData()
                })
                
            }
            
            }).resume()
  }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
    
            }.resume()
        

    }
    
    func downloadImage(url: URL, imageView: UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(data)
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
            imageView.image = UIImage(data: data)

            
            }

        }
    }
    
    
    //UITableView DataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return nameArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = typeArray[indexPath.row]
        
        let cellIdentifier1 = "TrackCell"
        let cellIdentifier2 = "VideoCell"
        let cellIdentifier3 = "AdsCell"

        
        //Display cell
        
        let mediaType: String = self.typeArray[indexPath.row]
        
        switch mediaType {
        case "track":
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier1) as! TrackTableViewCell
            self.playlist1UITableView.rowHeight = 90
            cell.nameLabel?.text = nameArray[indexPath.row]
            cell.nameLabel?.sizeToFit()
            let imageURL = NSURL(string: self.coverURLArray[indexPath.row])
            self.downloadImage(url: imageURL as! URL, imageView: cell.coverImageView)
            return cell
            
            
        case "video":
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2) as! VideoTableViewCell
            self.playlist1UITableView.rowHeight = 110
            cell.nameLabel?.text = nameArray[indexPath.row]
            cell.nameLabel?.sizeToFit()
            let imageURL = NSURL(string: self.coverURLArray[indexPath.row])
            self.downloadImage(url: imageURL as! URL, imageView: cell.coverImageView)
//            if(cell.coverImageView.image == nil){
//                cell.coverImageView.image = UIImage(named: "defaultVideoPhoto")
//            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier3) as! AdsTableViewCell
            self.playlist1UITableView.rowHeight = 224.5
            let imageURL = NSURL(string: self.coverURLArray[indexPath.row])
            self.downloadImage(url: imageURL as! URL, imageView: cell.coverImageView)
            return cell
        }



        
        
//        if (typeArray[indexPath.row] == "video"){
//                //print("Video")
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2) as! VideoTableViewCell
//            
//            let imageURL = NSURL(string: self.coverURLArray[indexPath.row])
//            self.downloadImage(url: imageURL as! URL, imageView: cell.coverImageView)
        
//            if imageURL != nil {
//
////                var data = NSData(contentsOf: ((imageURL as URL?))!)
////                //var data:NSData = NSData.dataWithContentsOfURL(url, options: nil, error: nil)
////   
////                
////                
////                if data != nil{
////                    cell.coverImageView.image = UIImage(data: data! as Data)
////                }
////                else{
////                    if (imageURL == nil){
////                        print("imageURL is nil")
////                        
////                    }else
////                    {
////                        print("imageURL is not nil")
////                        print(imageURL)
////                        
////                    }
////                    
////                    //print(self.coverURLArray[indexPath.row])
////                    print("data is nil")
////                    
////                    data = NSData(contentsOf: ((imageURL as URL?))!)
//                }
//                //cell.coverImageView.image = UIImage(data: data! as Data)
//            }else{
//                
////            }
//            return cell
//        }
//        else{
//            
//            
//               // print(typeArray[indexPath.row])
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier1) as! TrackTableViewCell
//            //cell?.textLabel?.text = nameArray[indexPath.row]
//            cell.nameLabel.text = nameArray[indexPath.row]
//            let imageURL = NSURL(string: self.coverURLArray[indexPath.row])
//            if imageURL != nil {
//                let data = NSData(contentsOf: (imageURL as URL?)!)
//                cell.coverImageView.image = UIImage(data: data! as Data)
//            
//            }

        }
    
    
}

