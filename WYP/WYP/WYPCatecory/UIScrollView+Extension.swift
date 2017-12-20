//
//  UIScrollView+Extension.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/12.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

extension UIScrollView: UIGestureRecognizerDelegate{
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
//        if (otherGestureRecognizer.view?.isKind(of: NSClassFromString("UITableViewWrapperView")!))! {
//            
//        }
        
        if otherGestureRecognizer.view?.superview != nil {
           return (otherGestureRecognizer.view?.superview?.isMember(of: UITableView.self))!
        } else {
            if (otherGestureRecognizer.view?.isMember(of: UITableView.self))!{
                return true
            }
        }
        return false
    }
}
