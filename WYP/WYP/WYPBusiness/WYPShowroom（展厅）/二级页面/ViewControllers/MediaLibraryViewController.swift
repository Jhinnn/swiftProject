//
//  MediaLibraryViewController.swift
//  WYP
//
//  Created by Arthur on 2018/1/22.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class MediaLibraryViewController: BaseViewController {
    
    // 展厅id
    var roomId: String?
    
    // 是否关联票务
    var isTicket: Int?
    
    
    
    // 媒体库数据源
    var mediaImageData: [MediaLibaryImageModel] = [MediaLibaryImageModel]()
    
    // 媒体库数据源
    var mediaVideoData: [MediaLibaryVideoModel] = [MediaLibaryVideoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor.white
        
        navigationItem.titleView = self.segmentControl
        
        setUpUI()
        
        getData(type: "")
        
    }
    
    func setUpUI() {

        self.view.addSubview(self.collectionView)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        if deviceTypeIPhoneX() {
            layout.sectionInset = UIEdgeInsets(top: 6, left: 6, bottom: 34 + 44, right: 6)  //外边距
        }else {
            layout.sectionInset = UIEdgeInsets(top: 6, left: 6, bottom: 70, right: 6)  //外边距
        }
        
        
        layout.itemSize = CGSize(width: (kScreen_width - 24) / 4, height: (kScreen_width - 24) / 4)
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib.init(nibName: "MediaVideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "videoCell")
        collectionView.register(UINib.init(nibName: "MediaImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        return collectionView
        
    }()
    
    //MARK: //获得所有数据
    func getData(type: String) {
        NetRequest.getMediaListNetRequest(type: type, id: self.roomId ?? "") { (success, info, result) in
            if success {
                
                if result != nil  {
                    let videoArrays = result?.value(forKey: "video") as? [NSDictionary]
                    if videoArrays != nil {
                        let data = try! JSONSerialization.data(withJSONObject: videoArrays!, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                        self.mediaVideoData = ([MediaLibaryVideoModel].deserialize(from: jsonString)! as! [MediaLibaryVideoModel])
                    }
                     let imageArrays = result?.value(forKey: "image") as? [NSDictionary]
                    if imageArrays != nil {
                        let datas = try! JSONSerialization.data(withJSONObject: imageArrays!, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let jsonStrings = NSString(data: datas, encoding: String.Encoding.utf8.rawValue)! as String
                        self.mediaImageData = ([MediaLibaryImageModel].deserialize(from: jsonStrings)! as! [MediaLibaryImageModel])
                    }
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    lazy var segmentControl: UISegmentedControl = {
        
        let segment = UISegmentedControl.init(items: ["全部","视频","图片"])
        segment.selectedSegmentIndex = 0

        //添加事件
        segment.addTarget(self, action: #selector(segmentedControlChanged(seg:)), for: UIControlEvents.valueChanged)
   
        return segment
        
    }()
    
    func segmentedControlChanged(seg: UISegmentedControl) {
        if seg.selectedSegmentIndex == 1 { //选中视频
            self.mediaImageData.removeAll()
            getData(type: "video")
        }
        if seg.selectedSegmentIndex == 2 {
            self.mediaVideoData.removeAll()
            getData(type: "image")
        }else if seg.selectedSegmentIndex == 0{
            getData(type: "")
        }
    }
    
    func showCurrentIndex(index: Int) {
        let photos = PhotosViewController()
        if self.mediaImageData.count != 0 {
            var imageArr = [String]()
            for model in self.mediaImageData {
                let imageUrl = model.address
                imageArr.append(imageUrl!)
            }
            photos.imageArray = imageArr
        }
        photos.currentIndex = index + 1
        self.present(photos, animated: false, completion: nil)
    }
   

}

extension MediaLibraryViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mediaImageData.count != 0 || self.mediaVideoData.count != 0 { //图片视频都有
            return self.mediaImageData.count + self.mediaVideoData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.mediaImageData.count != 0 || self.mediaVideoData.count != 0 {  //有图片 有视频
            if self.mediaVideoData.count > indexPath.row {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath)
                let imageView = cell.viewWithTag(100) as! UIImageView
                let model = self.mediaVideoData[indexPath.row]
                imageView.sd_setImage(with: URL.init(string: model.address!), placeholderImage: UIImage.init(color: UIColor.gray), options: SDWebImageOptions.retryFailed)
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
                let imageView = cell.viewWithTag(101) as! UIImageView
                let model = self.mediaImageData[indexPath.row - self.mediaVideoData.count]
                imageView.sd_setImage(with: URL.init(string: model.address!), placeholderImage: UIImage.init(color: UIColor.gray), options: SDWebImageOptions.retryFailed)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.mediaVideoData.count > indexPath.row {
            let videos = VideosViewController()
            let model = self.mediaVideoData[indexPath.row]
            videos.roomId = roomId
            videos.isTicket = isTicket ?? 0
            videos.roomTitle = model.title
            videos.videoId = model.id
            navigationController?.pushViewController(videos, animated: true)
        }else {
            showCurrentIndex(index: indexPath.item - (self.mediaVideoData.count))
        }
    }

    
    
}

