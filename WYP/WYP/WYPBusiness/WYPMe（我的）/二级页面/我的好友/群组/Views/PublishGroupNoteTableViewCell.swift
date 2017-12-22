//
//  PublishGroupNoteTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2017/12/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class PublishGroupNoteTableViewCell: UITableViewCell {
    
    var titleText: ((String?) -> Void)?
    
    var contentText: ((String?) -> Void)?
    
    var photoChange : (([UIImage]?)-> Void)?
    
    var images = [UIImage]()
    
//    var images: [UIImage]? {
//        didSet{
//            if images?.count == 0 {
//                contentView.addSubview(addBtn)
//                contentView.addSubview(promptLabel)
//            }else {
//                promptLabel.removeFromSuperview()
//                if  images?.count == 3 {
//                    addBtn.removeFromSuperview()
//                    for img in images! {
//                        let index = images?.index(of: img)
//                        let imageView = UIImageView.init(image: img)
//                        contentView.addSubview(imageView)
//                        imageView.snp.makeConstraints({ (make) in
//                            make.left.equalTo(12 + (12 + 72) * index!)
//                            make.size.equalTo(72)
//                            make.top.equalTo(lineView2.snp.bottom).offset(20)
//                        })
//                    }
//                }else {
//                    addBtn.snp.updateConstraints({ (make) in
//                        make.left.equalTo(12 + (72 + 12) * images!.count)
//                    })
//                    for img in images! {
//                        let index = images?.index(of: img)
//                        let imageView = UIImageView.init(image: img)
//                        contentView.addSubview(imageView)
//                        imageView.snp.makeConstraints({ (make) in
//                            make.left.equalTo(12 + (12 + 72) * index!)
//                            make.size.equalTo(72)
//                            make.top.equalTo(lineView2.snp.bottom).offset(20)
//                        })
//                    }
//                }
//            }
//        }
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setUIFrame()
    }
    
    func setUI() {
        contentView.addSubview(titleTextFeild)
        contentView.addSubview(lineView1)
        contentView.addSubview(contentTextView)
        contentView.addSubview(lineView2)
        contentView.addSubview(backView)
//        contentView.addSubview(promptLabel)
        backView.addSubview(photoView)
        backView.addSubview(photoView)
        photoView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
        })
    }
    
    func setUIFrame() {
        titleTextFeild.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextFeild.snp.bottom).offset(20)
            make.left.equalTo(12)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        contentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom).offset(20)
            make.left.equalTo(12)
            make.size.equalTo(CGSize.init(width: kScreen_width - 24, height: 200))
        }
        
        lineView2.snp.makeConstraints { (make) in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.left.equalTo(12)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom).offset(20)
            make.left.equalTo(12)
            make.size.equalTo(CGSize.init(width: kScreen_width - 24, height: 100))
        }
        
//        promptLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(backView)
//            make.left.equalTo(backView.snp.right).offset(24)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var titleTextFeild: UITextField = {
        let textFeild = UITextField()
        textFeild.placeholder = "2017年1月22日 群公告"
        textFeild.borderStyle = .none
        textFeild.addTarget(self, action: #selector(textFeildDidChange(sender:)), for: .editingChanged)
        return textFeild
    }()
    
    func textFeildDidChange(sender : UITextField) -> Void {
        if titleText != nil {
            titleText!(sender.text)
        }
    }
    
    lazy var lineView1: UIView = {
        let line1 = UIView()
        line1.backgroundColor = UIColor.init(hexColor: "e8e8e8")
        return line1
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width - 24, height: 200))
        textView.placeholder = "正文（必填），15——500字"
        textView.placeholderLabel.font = UIFont.systemFont(ofSize: 13)
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.delegate = self
        return textView
    }()
    
    lazy var lineView2: UIView = {
        let line2 = UIView()
        line2.backgroundColor = UIColor.init(hexColor: "e8e8e8")
        return line2
    }()
    
//    lazy var promptLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.init(hexColor: "333333")
//        label.text = "（添加图片不可超过3张）"
//        label.alpha = 0.3
//        label.font = UIFont.systemFont(ofSize: 13)
//        return label
//    }()
    
    lazy var manager: HXPhotoManager = {
        let manager = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
        manager?.openCamera = true
        manager?.outerCamera = true
        manager?.photoMaxNum = 3
        manager?.maxNum = 3
        manager?.showFullScreenCamera = true
        return manager!
    }()
    
    lazy var photoView: HXPhotoView = {
        let photoView = HXPhotoView(frame: CGRect.zero, with: self.manager)
        photoView?.delegate = self
        return photoView!
    }()
    
    lazy var backView : UIView = {
        let backView = UIView()
        return backView
    }()
    
}

extension PublishGroupNoteTableViewCell : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if contentText != nil {
            contentText!(textView.text)
        }
    }
}

extension PublishGroupNoteTableViewCell: HXPhotoViewDelegate {
    func photoViewUpdateFrame(_ frame: CGRect, with view: UIView!) {
        
    }
    
    func photoViewDeleteNetworkPhoto(_ networkPhotoUrl: String!) {
        if self.images.count == 0 {
//            self.contentView.addSubview(promptLabel)
//            backView.snp.updateConstraints { (make) in
//                make.width.equalTo(72)
//            }
        }
    }
    
    func photoViewChangeComplete(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
        self.images.removeAll()
        for model in photos {
            self.images.append(model.thumbPhoto)
        }
        if photoChange != nil {
            photoChange!(self.images)
        }
//        promptLabel.removeFromSuperview()
//        backView.snp.updateConstraints { (make) in
//            make.width.equalTo(240)
//        }
    }
}
