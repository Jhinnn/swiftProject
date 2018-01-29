//
//  RoomCommentFrameModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TalkRoomCommentFrameModel: NSObject {

    // 头像的frame
    var headImgUrlF: CGRect?
    
    // 昵称的frame
    var nickNameF: CGRect?
    
    // 点赞数
    var starCountF: CGRect?
    
    // 内容的frame
    var contentF: CGRect?
    
    // 时间的frame
    var timeF: CGRect?
    
    //关注的frame
    var followF: CGRect?
    
    // 回复数的frame
    var replyCountF: CGRect?
    
    // 回复按钮的frame
    var replyButtonF: CGRect?
    
    // 单元格的高度
    var cellHeight: CGFloat?
    
    // 图片1高度
    var image1F: CGRect?
    
    // 图片1高度
    var image2F: CGRect?
    
    // 图片1高度
    var image3F: CGRect?
    
    //赞
    var zanLabelF: CGRect?
    //阅读
    var readLabelF: CGRect?
    var lineLabelF: CGRect?
    
    
    
    // 数据模型
    var comment: CommentModel! {
        willSet {
            headImgUrlF = CGRect(x: 13, y: 17.5, width: 40, height: 40)
            
            nickNameF = CGRect(x: (headImgUrlF?.maxX)! + 14, y:30 , width: 200, height: 14.5)
            
            followF = CGRect(x: kScreen_width - 95, y: 30, width: 80, height: 14)
            
            let contentStr = newValue.content_text?.replacingOccurrences(of: "\n", with: "")
            
            let contentSize = self.getLabHeigh(labelStr: contentStr!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
            

            contentF = CGRect(x: 13, y: (headImgUrlF?.maxY)! + 10, width:  kScreen_width - 26, height: contentSize)
            
            
            
            if newValue.content_img?.count != 0 {  //有图片
                if newValue.content_img?.count == 1 {
                    image1F = CGRect(x: (contentF?.minX)!, y: (contentF?.maxY)! + 8, width: 120, height: 120)
                    image2F = CGRect(x: (contentF?.minX)! + 100, y: (contentF?.maxY)! + 10, width: 80, height: 0)
                    image3F = CGRect(x: (contentF?.minX)! + 185, y: (contentF?.maxY)! + 10, width: 80, height: 0)
                }else if newValue.content_img?.count == 2 {
                    image1F = CGRect(x: (contentF?.minX)!, y: (contentF?.maxY)! + 8, width: 100, height: 100)
                    image2F = CGRect(x: (contentF?.minX)! + 105, y: (contentF?.maxY)! + 8, width: 100, height: 100)
                    image3F = CGRect(x: (contentF?.minX)! + 185, y: (contentF?.maxY)! + 10, width: 80, height: 0)
                }else if newValue.content_img?.count == 3 {
                    image1F = CGRect(x: (contentF?.minX)! , y: (contentF?.maxY)! + 8, width: 100, height: 100)
                    image2F = CGRect(x: (contentF?.minX)! + 105, y: (contentF?.maxY)! + 8, width: 100, height: 100)
                    image3F = CGRect(x: (contentF?.minX)! + 210, y: (contentF?.maxY)! + 8, width: 100, height: 100)
                }
                zanLabelF = CGRect(x: (image1F?.minX)!, y: (image1F?.maxY)! + 10, width: 60, height: 20)
                readLabelF = CGRect(x: (zanLabelF?.maxX)!, y: (image1F?.maxY)! + 10, width: 60, height: 20)
            }else {  //没有图片
                
                image1F = CGRect(x: (headImgUrlF?.minX)! + 15, y: (contentF?.maxY)! + 10, width: 80, height: 0)
                image2F = CGRect(x: (headImgUrlF?.minX)! + 100, y: (contentF?.maxY)! + 10, width: 80, height: 0)
                image3F = CGRect(x: (headImgUrlF?.minX)! + 185, y: (contentF?.maxY)! + 10, width: 80, height: 0)
                zanLabelF = CGRect(x: (contentF?.minX)!, y: (contentF?.maxY)! + 10, width: 60, height: 20)
                readLabelF = CGRect(x: (zanLabelF?.maxX)!, y: (contentF?.maxY)! + 10, width: 60, height: 20)
                
            }
           
            lineLabelF = CGRect(x: 0, y: (zanLabelF?.maxY)! + 6, width: kScreen_width, height: 9)
    
            cellHeight = (lineLabelF?.maxY)!
            
            
            
        }
    }
    
    func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let statusLabelText: String = labelStr
        
        let size = CGSize(width: width, height: 200)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        
        return strSize.height
        
    }
    
    override init() {
        super.init()
    }
}
