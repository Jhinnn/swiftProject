    //
//  NetRequest.swift
//  WYP
//
//  Created by 你个LB on 2017/4/11.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetRequest {
    
    var alamofireManager : SessionManager?
    // 设置请求的超时时间
    let config = URLSessionConfiguration.default.timeoutIntervalForRequest
    
    
    // 获取当前版本号
    class func getCurrentVersion(complete: @escaping ((Bool, [NSDictionary?]?) -> Void)) {
        let parameters: Parameters = ["id": "1266624898"]
        
        Alamofire.request("https://itunes.apple.com//lookup", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取数据
                let arr = json.dictionary?["results"]?.rawValue as? [NSDictionary?]
                complete(true, arr)
            case .failure(let error):
                print(error)
            }
        }

    }
    
    // 通过uid获取用户昵称、头像 1
    class func getUserNickNameAndHeadImgUrlNetRequest(userId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": userId]
        Alamofire.request(kApi_getUserInfo, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 通过uid获取群组昵称、头像
    class func getGroupNameAndHeadImgUrlNetRequest(groupId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "gid": groupId]
        Alamofire.request(kApi_getGroupInfo, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 我的消息列表
    
    class func myNotificationListNetRequest(page: String, token: String, complete: @escaping ((Bool, String?, [NSDictionary?]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "page": page]
        Alamofire.request(kApi_my_notification, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let arr = json.dictionary?["data"]?.rawValue as? [NSDictionary?]
                    complete(true, info, arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    // 删除我的消息
    class func deleteNotificationNetRequest(openId: String, id: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "id": id]
        print(openId)
        Alamofire.request(kApi_deleteNotification, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    class func myCouponListNetRequest(page: String, token: String, complete: @escaping ((Bool, String?, [NSDictionary?]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "page": page]
        Alamofire.request(kApi_my_coupon, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let arr = json.dictionary?["data"]?.rawValue as? [NSDictionary?]
                    complete(true, info, arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 我的话题列表
    
    class func myTopicListNetRequest(page: String, token: String, complete: @escaping ((Bool, String?, [NSDictionary?]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "page": page]
        Alamofire.request(kApi_my_topicList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let arr = json.dictionary?["data"]?.rawValue as? [NSDictionary?]
                    complete(true, info, arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //我的话题列表---新
    class func myNewTopicListNetRequest(page: String, token: String, uid: String, complete: @escaping ((Bool, String?, [NSDictionary?]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "is_login_uid" : uid,
                                      "uid" : uid,
                                      "page": page]
        Alamofire.request(kApi_my_topicListnew, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据

                    let dic = json["data"].dictionaryValue

                    let arr = dic["gambit"]?.rawValue as? [NSDictionary?]

                    complete(true, info, arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //我的回答的话题列表---新
    class func myAnswerTopicListNetRequest(page: String, token: String, uid: String, complete: @escaping ((Bool, String?, [NSDictionary?]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "is_login_uid" : uid,
                                      "uid" : uid,
                                      "page": page]
        Alamofire.request(kApi_myAnswer_topicListnew, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    
                    let dic = json["data"].dictionaryValue
                    
                    let arr = dic["gambit"]?.rawValue as? [NSDictionary?]
                    
                    complete(true, info, arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯 - 话题评论
    class func topicsCommentNetRequest(openId: String, topicId: String, content: String, pid: String, complete: @escaping ((Bool, String?) -> Void)) {
        
        
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "id": topicId,
                                      "content": content,
                                      "pid": pid]
        Alamofire.request(kApi_topicsComment, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯 - 话题评论(可附带图片)
    class func topicsCommentImagesNetRequest(openId: String, topicId: String, content: String, pid: String,images: [UIImage], complete: @escaping ((Bool, String?) -> Void)) {
        
        
        var i = 1
        var infoDic:[String: String] = [String: String]()
        for image in images {
            // 压缩图片
            let fileData = UIImageJPEGRepresentation(image, 0.4)
            let base64String = fileData?.base64EncodedString(options: .endLineWithCarriageReturn)
            let imageName = "baseImg\(i)"
            infoDic[imageName] = base64String ?? ""
            i = i + 1
        }
        
        var parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "id": topicId,
                                      "content": content,
                                      "pid": pid]
        
        for (key, value) in infoDic {
            parameters[key] = value
        }
        
        
        Alamofire.request(kApi_topicsComment, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    //我的话题列表---新
    class func myNewTopicMsgListNetRequest(page: String, token: String, uid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "is_login_uid" : uid,
                                      "uid" : uid,
                                      "page": page]
        Alamofire.request(kApi_my_topicListnew, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info,dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - 删除我的话题
    class func deleteMyTopicNetRequest(token: String, topicId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "id": topicId]
        Alamofire.request(kApi_del_my_topic, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    // 获取数据
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 反馈建议
    class func feedbackIdeaNetRequest(token: String, text: String, pid: String, vyid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "content": text,
                                      "pid": pid,
                                      "vyid": vyid]
        Alamofire.request(kApi_feedback_idea, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    // 反馈成功
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - 用户登录
    
    class func loginNetRequest(uuid: String, phoneNumber: String, password: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uuid": uuid,
                                      "username": phoneNumber,
                                      "password": password,
                                      "jpush_id":JPUSHService.registrationID()]
        Alamofire.request(kApi_login, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 第三方登录
    
    class func thirdPartyLoginNetRequest(uuid: String, token: String, type: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "token": token,
                                      "type": type,
                                      "uuid": uuid]
        Alamofire.request(kApi_third_party_login, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result { 
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 发送验证码
    class func sendVerificationCodeNetRequest(phoneNumber: String, action: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "account": phoneNumber,
                                      "type": "mobile",
                                      "action": action]

        Alamofire.request(kApi_sendVerificationCode, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    // 发送验证码成功
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 用户注册
    class func registerNetRequest(phoneNumber: String, verifyCode: String, password: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "nickname": phoneNumber,
                                      "mobile": phoneNumber,
                                      "reg_verify": verifyCode,
                                      "password": password]
        Alamofire.request(kApi_register, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    // 获取数据
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 验证短信验证码
    
    class func verifyCodeNetRequest(phoneNumber: String, verifyCode: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "mobile": phoneNumber,
                                      "verify": verifyCode]
        Alamofire.request(kApi_verifyCode, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 忘记密码
    class func forgetPasswordNetRequest(phoneNumber: String, password: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "mobile": phoneNumber,
                                      "password": password]
        Alamofire.request(kApi_reset_password, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 修改密码
    class func modifyPasswordNetRequest(oldPassword: String, newPassword: String, token: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "old_password": oldPassword,
                                      "new_password": newPassword,
                                      "open_id": token]
        Alamofire.request(kApi_modify_password, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 修改用户资料
    class func editUserInfoNetRequest(infoDic: [String: Any], token: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        var parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token]
        parameters.updateValue(infoDic.values.first!, forKey: infoDic.keys.first!)
        print(parameters)
        Alamofire.request(kApi_edit_user_info, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 首页兑换
    class func exchangeNetRequest(token: String, code: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "code": code]
        Alamofire.request(kApi_home_exchange, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 获取收货地址接口
    class func getGoodsAddressNetRequest(openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId]
        Alamofire.request(kApi_get_goods_address, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                print(info)
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    if (dic?.count ?? 0) != 0 {
                        complete(true, info, dic)
                    }
                    complete(false, info, nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 获取用户资料
    class func getUserInfoNetRequest(token: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token]
        Alamofire.request(kApi_get_user_info, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    // MARK: - 首页相关接口
    // 群组列表页接口
    class func groupListNetRequest(page: String, uid: String, gid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "uid": uid,
                                      "gid":gid,
                                      "page": page]
        Alamofire.request(kApi_groupList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 发布话题
    class func issueTopicNetRequest(token: String, typeId: String, text: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": token,
                                      "type": typeId,
                                      "content": text]
        Alamofire.request(kApi_issue_Topic, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    // MARK: - 资讯相关
    // 资讯列表接口
    class func newsNetRequest(page: String, type_id: String, uid: String, userId: String, upParams: Int, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "id": type_id,
                                      "uid": uid,
                                      "user_id": userId,
                                      "upParams": upParams,
                                      "page": page]
        
        Alamofire.request(kApi_news, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 展厅相关
    // 展厅列表接口
    class func showRoomNetRequest(page: String,id: String, type_id: String, order: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "page": page,
                                      "type_id": type_id,
                                      "id" : id,
                                      "order": order]
        Alamofire.request(kApi_showRoom, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 展厅相关
    // 展厅筛选列表接口
    class func showFilterRoomNetRequest(page: String, id: String, order: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "page": page,
                                      "id": id,
                                      "order": order]
        Alamofire.request(kApi_showFilterRoom, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情
    class func showRoomDetailNetRequest(page: String, uid: String, type_id: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "uid": uid,
                                      "id": type_id,
                                      "page": page]
        Alamofire.request(kApi_showRoomDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 展厅收藏按钮
    class func collectionRoomNetRequest(openId: String, id: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "id": id]
        Alamofire.request(kApi_collection, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    // 获取数据
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 演职人员列表
    class func actorMemberNetRequest(uid: String, id: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "uid": uid,
                                      "id": id]
        Alamofire.request(kApi_actorMember, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 添加取消关注
    class func addOrCancelAttentionNetRequest(method: String, mid: String, follow_who: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": method,
                                      "mid": mid,
                                      "follow_who": follow_who]
        Alamofire.request(kApi_addOrCancelAttention, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    // 获取数据
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 最新动态更多按钮
    class func roomDetailNewsNetRequest(page: String, id: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "id": id,
                                      "page": page]
        Alamofire.request(kApi_roomDetailNews, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 点赞
    class func thumbUpNetRequest(id: String, uid: String ,complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "id": id,
                                      "uid": uid]
        Alamofire.request(kApi_thumbUp, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    // 获取数据
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    // 展厅详情 - 发布展厅评论
    class func issueCommentNetRequest(openId: String, groupId: String, content: String, pid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "gid": groupId,
                                      "content": content,
                                      "pid": pid]
        Alamofire.request(kApi_issueComment, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    // 展厅详情 - 企业认证
    class func comanyCertificationNetRequest(roomId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "id": roomId]
        Alamofire.request(kApi_companyCertification, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json["data"].rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 热门资讯更多按钮
    class func homeHotNewsNetRequest(page: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "page": page]
        Alamofire.request(kApi_homeHotNews, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // 首页 - 首页列表
    class func homeListNetRequest(uid: String, upnumb: Int, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "upParams": upnumb,
                                      "uid": uid]
        Alamofire.request(kApi_homeList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json["data"].rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯 - 搜索结果页面
    class func newsSearchNetRequest(title: String, categoryId: String, page: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "title": title,
                                      "category_id": categoryId,
                                      "page": page]
        Alamofire.request(kApi_newsSearch, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 关注的资讯 kApi_attentionNews
    class func attentionNewsNetRequest(page: String, openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "page": page]
        Alamofire.request(kApi_attentionNews, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // 我的 - 关注的话题 kApi_attentionNews
    class func attentionTopicNetRequest(page: String, openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "page": page]
        Alamofire.request(kApi_attentionTopic, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

    // 我的 - 取消关注资讯
    class func cancelAttentionNetRequest(openId: String, newsId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "news_id": newsId]
        Alamofire.request(kApi_newsCancelAttention, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 票务相关
    // 票务列表
    class func ticketListNetRequest(cityId: String, page: String, type: String, classPid: String, classId: String, longitude: String, latitude: String, keywords: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "type": type,
                                      "class_pid": classPid,
//                                      "class_id": classId,
                                      "longitude": longitude,
                                      "latitude": latitude,
                                      "keywords": keywords,
                                      "page": page,
//                                      "city_id": cityId
        ]
        Alamofire.request(kApi_ticketList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    // 票务 - 票务详情
    class func ticketDetailNetRequest(roomId: String, ticketId: String, openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "id": roomId,
                                      "tid": ticketId,
                                      "open_id": openId]
        Alamofire.request(kApi_ticketDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯 - 点击视频接口
    class func newsVideoDetailNetRequest(page: String,uid: String, newsId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "news_id": newsId,
                                      "uid": uid,
                                      "page": page]
        Alamofire.request(kApi_newsVideoDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    // 展厅详情 - 视频接口
    class func roomDetailVideoNetRequest(videoId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "id": videoId]
        Alamofire.request(kApi_roomDetailVideo, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // 展厅详情 - 图集接口
    class func roomDetailPhotoNetRequest(photoId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "id": photoId]
        Alamofire.request(kApi_roomDetailPhoto, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 票务 - 二级分类搜索
    class func ticketSecondSearchNetRequest(page: String, type: String, keyword: String, classPid: String, classId: String, longitude: String, latitude: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "type": type,
                                      "keywords": keyword,
                                      "class_pid": classPid,
                                      "class_id": classId,
                                      "longitude": longitude,
                                      "latitude": latitude,
                                      "page": page]
        Alamofire.request(kApi_ticketSecSearch, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 更多热门话题
    class func homeHotTopicNetRequest(uid: String, page: String, complete: @escaping ((Bool, String?, [NSDictionary?]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "id": uid,
                                      "page": page]
        Alamofire.request(kApi_homeHotTopic, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let arr = json.dictionary?["data"]?.rawValue as? [NSDictionary?]
                    complete(true, info, arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 热门搜索
    class func hotSearchNetRequest(complete: @escaping ((Bool, String?, [String]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST"]
        Alamofire.request(kApi_hotSearch, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let arr = json.dictionary?["data"]?.rawValue as? [String]
                    complete(true, info, arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅 - 搜索结果页
    class func roomSearchNetRequest(keyword: String, page: String, typeId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "keyword": keyword,
                                      "page": page,
                                      "type_id": typeId]
        Alamofire.request(kApi_roomSearch, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 关注的人
    class func attentionPeopleNetRequest(page: String, openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "page": page]
        Alamofire.request(kApi_attentionPeoples, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //个人资料
    class func requestMyhome(tarUId: String, muid: String ,complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "is_login_uid": muid,
                                      "uid": tarUId]
        Alamofire.request(kApi_my_home, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // 我的 - 取消关注的人
    class func peopleCancelAttentionNetRequest(openId: String, peopleId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "follow_who": peopleId,
                                      "type" : "1"]
        Alamofire.request(kApi_peopleCancelAttention, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 关注的票务
    class func attentionTicketNetRequest(page: String, openId: String, longitude: String, latitude: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "longitude": longitude,
                                      "latitude": latitude,
                                      "page": page]
        Alamofire.request(kApi_attentionTickets, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 取消关注的票务
    class func ticketCancelAttentionNetRequest(openId: String, ticketId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "tid": ticketId]
        Alamofire.request(kApi_ticketCancelAttention, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 添加好友搜索列表
    class func addSearchFriendsNetRequest(openId: String, keyword: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "comment": keyword]
        Alamofire.request(kApi_addSearchFriends, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 关注票务
    class func addAttentionTicketNetRequest(openId: String, ticketId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "tid": ticketId]
        Alamofire.request(kApi_addAttentionTicket, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 话题详情
    class func topicDetailsNetRequest(page: String, uid: String, topicId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "id": topicId,
                                      "page": page]
        Alamofire.request(kApi_topicDetails, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯 - 话题点赞和评论点赞
    class func topicStarNetRequest(openId: String, newsId: String, typeId: String, cid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "news_id": newsId,
                                      "type": typeId,
                                      "cid": cid]
        Alamofire.request(kApi_topicStar, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
  
    
    // 我的 -加入群组
    class func myGroupsListNetRequest(openId: String, page: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "page": page]
        Alamofire.request(kApi_myGroupsList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 -管理群组
    class func myGroupsListChangeNetRequest(openId: String, page: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "page": page]
        Alamofire.request(kApi_myGroupsChangeList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 热门发现更多按钮
    class func homeHotRoomNetRequest(page: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "page": page]
        Alamofire.request(kApi_homeHotRoom, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 关注的展厅
    class func attentionRoomsNetRequest(page: String, openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "page": page]
        Alamofire.request(kApi_attentionRooms, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 取消关注的展厅
    class func roomCancelAttentionNetRequest(openId: String, groupId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "gid": groupId]
        Alamofire.request(kApi_roomCancelAttention, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 删除动态
    class func deleteCommunityNetRequest(openId: String, cid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "cid": cid]
        Alamofire.request(kApi_deleteCommunity, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    // 我的 - 邀请好友
    class func inviteFriendsNetRequest(page: String, uid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "page": page]
        Alamofire.request(kApi_inviteFriends, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 反馈记录
    class func feedBackRecordNetRequest(page: String, openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "page": page]
        Alamofire.request(kApi_feedBackRecord, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 我的订单
    class func myOrdersNetRequest(page: String, uid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "page": page]
        Alamofire.request(kApi_myOrders, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 收货地址
    class func goodsInfoNetRequest(uid: String, ticketTimeId: String, type: String, walletId: String, invitationId: String, name: String, phone: String, postcode: String, region: String, address: String, ticketName: String, complete: @escaping ((Bool, String?) -> Void)) {
        var parameters: Parameters!
        if type == "1" {
            parameters = ["access_token": access_token,
                          "method": "POST",
                          "uid": uid,
                          "ticket_time_id": ticketTimeId,
                          "type": type,
                          "wallet_id": walletId,
                          "name": name,
                          "phone_number": phone,
                          "postcode": postcode,
                          "region": region,
                          "address": address,
                          "ticket_name": ticketName]
        } else {
            parameters = ["access_token": access_token,
                          "method": "POST",
                          "uid": uid,
                          "ticket_time_id": ticketTimeId,
                          "type": type,
                          "invitation_id": invitationId,
                          "name": name,
                          "phone_number": phone,
                          "postcode": postcode,
                          "region": region,
                          "address": address,
                          "ticket_name": ticketName]
        }

        Alamofire.request(kApi_goodsInfo, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 项目认证
    class func projectCertificationNetRequest(gid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "gid": gid]
        Alamofire.request(kApi_projectCertification, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯详情 - 评论列表
    class func newsCommentListNetRequest(page: String, newsId: String, uid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "news_id": newsId,
                                      "page": page]
        Alamofire.request(kApi_newsCommentList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 反馈详情
    class func recordsDetailNetRequest(recordId: String, code: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "vcode": code]
        Alamofire.request(kApi_recordDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 好友验证申请
    class func verifyApplicationNetRequest(openId: String, mobile: String, info: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "mobile": mobile,
                                      "message": info]
        Alamofire.request(kApi_verifyApplication, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯 - 关注资讯
    class func collectionNewsNetRequest(openId: String, newsId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "news_id": newsId]
        Alamofire.request(kApi_collectionNews, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯 - 图集浏览接口
    class func pictureSeeNetRequest(newsId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "news_id": newsId]
        Alamofire.request(kApi_pictureSee, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 好友列表
    class func friendsListNetRequest(openId: String, page: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId,
                                      "page": page]
        Alamofire.request(kApi_friendsList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页搜索
    class func homeSearchNetRequest(keyword: String, longitude: String, latitude: String, complete: @escaping ((Bool, String?, NSDictionary?,[NSDictionary]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "keyword": keyword,
                                      "longitude": longitude,
                                      "latitude": latitude]
        Alamofire.request(kApi_homeSearch, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil,nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    let arr = dic!["Dynamic"] as! [NSDictionary]
                    complete(true, info, dic,arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 搜索票务更多
    class func homeSearchMoreTicketNetRquest(page: String, keyword: String, longitude: String, latitude: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "keyword": keyword,
                                      "longitude": longitude,
                                      "latitude": latitude,
                                      "page": page]
        Alamofire.request(kApi_homeSearchTicket, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 搜索展厅更多
    class func homeSearchMoreRoomsNetRquest(page: String, keyword: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "keyword": keyword,
                                      "page": page]
        Alamofire.request(kApi_homeSearchRoom, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 搜索资讯更多
    class func homeSearchMoreNewsNetRquest(page: String, keyword: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "keyword": keyword,
                                      "page": page]
        Alamofire.request(kApi_homeSearchNews, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 搜索资讯更多
    class func homeSearchMoreGambitNetRquest(page: String, keyword: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "keyword": keyword,
                                      "page": page]
        Alamofire.request(kApi_homeSearchGambit, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 首页 - 搜索社区更多
    class func homeSearchMoreCommNetRquest(page: String, keyword: String, complete: @escaping ((Bool, String?, [NSDictionary]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "keyword": keyword,
                                      "page": page,
            "uid" :AppInfo.shared.user?.userId ?? ""]
        Alamofire.request(kApi_homeSearchCommunity, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
//                    let dic = json.rawValue as? NSDictionary
                    let arr = json.dictionary?["data"]?.rawValue as! [NSDictionary]
                    complete(true, info, arr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // 我的 - 群组信息
    class func groupInfoNetRequest(uid: String, groupId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "id": groupId,
                                      "is_login_uid": uid]
        Alamofire.request(kApi_groupInfo, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 获取管理群接口
    class func managerGroupNetRequest(id: String, open_id: String?, complete: @escaping((Bool, String?, NSDictionary?) -> Void)) {
        let parameters : Parameters = ["access_token": access_token,
                                       "method": "GET",
                                       "id": id,
                                       "open_id": open_id!]
        Alamofire.request(kApi_getManagerGroupInfo, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    class func setGroupManagerNetRequest(id: String?, uid: String?, open_id: String?, complete: @escaping((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "id": id!,
                                      "uid": uid!,
                                      "open_id": open_id!]
        Alamofire.request(kApi_setGroupManager, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 更改入群方式
    class func changeJoinGroupWayNetRequest(open_id: String?, id: String?, check : String?, complete: @escaping((Bool, String? , NSDictionary?) -> Void)) {
        let parameters : Parameters = ["access_token": access_token,
                                       "method": "POST",
                                       "open_id": open_id!,
                                       "id": id!,
                                       "check": check!]
        Alamofire.request(kApi_changeJoinGroupWay, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 删除群成员
    class func deleteGroupMemberNetRequest(open_id: String?, uid: String?, gid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters : Parameters = ["access_token": access_token,
                                       "method": "POST",
                                       "open_id": open_id!,
                                       "uid": uid!,
                                       "gid": gid]
        Alamofire.request(kApi_deleteGroupMember, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 邀请好友加入该群
    class func invitationJoinGroupNetRequest(open_id: String?, uid: String?, gid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters : Parameters = ["access_token": access_token,
                                       "method": "POST",
                                       "open_id": open_id!,
                                       "uid": uid!,
                                       "gid": gid]
        Alamofire.request(kApi_invitationJoinGroup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 群组公告列表
    class  func getGroupNoteListNetRequest(page: String, groupId: String, complete: @escaping ((Bool, String?, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "rid": groupId,
                                      "page": page,
                                      "limit": "10"]
        Alamofire.request(kApi_groupNoteList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let array = json.dictionary?["data"]?.rawValue as? [[NSObject: AnyObject]]
                    let data = try? JSONSerialization.data(withJSONObject: array as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    complete(true, info, strJson! as String)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 发布群组公告
    class func publishGroupNoteNetRequest(rid: String?, open_id: String?, title: String?, content: String?, images: [String], complete: @escaping((Bool, String) -> Void)) {
        var parameters : Parameters = ["access_token": access_token,
                                       "method": "POST",
                                       "rid": rid!,
                                       "open_id": open_id!,
                                       "title": title!,
                                       "description": content!]
        
        for imgStr in images {
            let index = images.index(of: imgStr)
            parameters["baseImg" + "\(index! + 1)"] = imgStr
        }
        Alamofire.request(kApi_publishGroupNote, method: .post, parameters: parameters, encoding: URLEncoding.default
            , headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    // 获取code码
                    let code = json["code"].intValue
                    // 获取info信息
                    let info = json["info"].stringValue
                    if code == 400 {
                        complete(false, info)
                    } else {
                        complete(true, info)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    
    // 群组 - 申请入群
    class func enterGroupNetRequest(type: String, openId: String, groupId: String, comment: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "gid": groupId,
                                      "content": comment,
                                      "type": type]
        Alamofire.request(kApi_enterGroup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 群组 - 筛选
    class func groupSearchNetRequest(page: String, keyword: String, typeId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "keyword": keyword,
                                      "type_id": typeId,
                                      "uid": AppInfo.shared.user?.userId ?? "",
                                      "page": page]
        Alamofire.request(kApi_groupSearch, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 登录注册 - 绑定手机号
    class func bindingMobileNetRequest(nickname: String, path: String, sex: String, mobile: String, verify: String, password: String, token: String, type: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "nickname": nickname,
                                      "path": path,
                                      "sex": sex,
                                      "mobile": mobile,
                                      "verify": verify,
                                      "password": password,
                                      "token": token,
                                      "type": type]
        Alamofire.request(kApi_bindingMobile, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 设置 - 第三方绑定
    class func userBindingNetRequest(token: String, type: String, uid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "token": token,
                                      "type": type,
                                      "uid": uid]
        Alamofire.request(kApi_userBinding, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 设置 - 解除绑定
    class func unBindingNetRequest(uid: String, type: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "type": type]
        Alamofire.request(kApi_unBinding, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 设置 - 用户绑定状态
    class func userBindingStatusNetRequest(uid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid]
        Alamofire.request(kApi_bindingStatus, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 展厅评论详情
    class func showRoomCommentDetailNetRequest(page: String, pid: String, uid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "pid": pid,
                                      "page": page]
        Alamofire.request(kApi_showRoomCommentDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 我的 - 保存收货地址
    class func saveMyAddressNetRequest(openId: String, name: String, phone: String, postcode: String, region: String, address: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "name": name,
                                      "phone_number": phone,
                                      "postcode": postcode,
                                      "region": region,
                                      "address": address]
        Alamofire.request(kApi_saveMyAddress, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //系统设置 - 通用 - 获取当前权限信息
    class func currentPrivacyInfoNetRequest(openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId]
        Alamofire.request(kApi_currentPrivacyInfo, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 系统设置 - 通用 - 不允许看我的朋友圈
    class func unallowLookMyCommunityNetRequest(uid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid]
        Alamofire.request(kApi_unallowLookMyCommunity, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 系统设置 - 通用 - 不允许添加我为好友
    class func unallowAddMeNetRequest(openId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "open_id": openId]
        Alamofire.request(kApi_unallowAddMe, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯详情 - 资讯评论详情
    class func newsCommentDetailNetRequest(page: String, pid: String, uid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "pid": pid,
                                      "page": page]
        Alamofire.request(kApi_newsCommentDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 退群
    class func quiteGroupNetRequest(openId: String, groupId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "gid": groupId]
        Alamofire.request(kApi_quiteGroup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 推荐好友
    class func recommendFriendsNetRequest(pushid: Any, nickname: String, groupName: String, groupId: String, uid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "pushid": pushid,
                                      "nickname": nickname,
                                      "gname": groupName,
                                      "gid": groupId,
                                      "uid": uid]
        Alamofire.request(kApi_recommendFriends, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 资讯评论列表
    class func roomNewsCommentListNetRequest(page: String, uid: String, newsId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "new_id": newsId,
                                      "page": page]
        Alamofire.request(kApi_roomNewsCommentList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 资讯评论
    class func roomNewsCommentNetRequest(pid: String, newId: String, uid: String, comment: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "new_id": newId,
                                      "pid": pid,
                                      "comment": comment,
                                      "uid": uid]
        Alamofire.request(kApi_roomNewsComment, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 资讯评论点赞
    class func roomNewsThumbUpNetRequest(commentId: String, uid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "id": commentId,
                                      "uid": uid]
        Alamofire.request(kApi_roomNewsThumbUp, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 资讯二级评论列表
    class func roomNewsSecCommentListNetRequest(uid: String, pid: String, page: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "pid": pid,
                                      "page": page]
        Alamofire.request(kApi_roomNewsSecCommentList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 群组聊天 - 获取用户信息进社区
    class func gotoUserCommunityNetRequest(uid: String, openId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "open_id": openId]
        Alamofire.request(kApi_gotoUserCommunity, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 展厅详情 - 最新动态关注
    class func roomNewsAttentionNetRequest(newsId: String, openId: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "news_id": newsId,
                                      "open_id": openId]
        Alamofire.request(kApi_roomNewsAttention, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 广告
    // 首页广告轮播图
    class func homeAdv(complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST"]
        Alamofire.request(kApi_homeAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 资讯广告轮播图
    class func newsAdv(complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST"]
        Alamofire.request(kApi_newsAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 发现广告轮播图
    class func showRoomAdv(complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST"]
        Alamofire.request(kApi_showRoomAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 抽奖广告轮播图
    class func lotteryAdv(complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST"]
        Alamofire.request(kApi_lotteryAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 问答广告轮播图
    class func questionAdv(complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST"]
        Alamofire.request(kApi_questionAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 投票广告轮播图
    class func voteAdv(complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST"]
        Alamofire.request(kApi_voteAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 开屏广告数据
    class func startAdv(complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST"]
        Alamofire.request(kApi_startAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 消息推送
    class func notificationPush(uid: String, content: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "text": content]
        Alamofire.request(kApi_notificationPush, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 支付
    class func weChatPayNetRequest(uid: String, orderName: String, spbillIp: String, totalFee: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "orderName": orderName,
                                      "spbillIp": spbillIp,
                                      "totalFee": totalFee]
        Alamofire.request(kApi_weChatPay, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //每日大转盘
    class func everyLotteryNetRequest(uid: String, complete: @escaping ((Bool) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid]
        Alamofire.request(kApi_everyLottery, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                if code == 400 {
                    complete(false)
                } else {
                    complete(true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 城市搜索
    class func citySearchNetRequest(keywords: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "keywords": keywords]
        Alamofire.request(kApi_citySearch, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 账号是否在其他设备登录
    class func isSingleLogin(uid: String, uuid: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "uuid": uuid]
        Alamofire.request(kApi_singleLogin, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 分享弹框广告
    class func shareAdvNetRequest(complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                     "method": "POST"]
        Alamofire.request(kApi_shareAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 点击广告
    class func clickAdvNetRequest(advId: String) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "adv_id": advId]
        Alamofire.request(kApi_clickAdv, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
        }
    }
    
    // 订单详情
    class func orderDetailNetRequest(uid: String, orderId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": uid,
                                      "e_id": orderId]
        Alamofire.request(kApi_orderDeatil, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 确认收货
    class func confirmReceiptNetRequest(orderId: String, complete: @escaping ((Bool) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "id": orderId]
        Alamofire.request(kApi_confirmReceipt, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                if code == 400 {
                    complete(false)
                } else {
                    complete(true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    // 通过id获取图集信息
    class func getPhotoDeatilsNetRequest(photoId: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["id": photoId]
        Alamofire.request(kApi_getPhotoDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //发布话题
    class func publishTopicNetRequest(open_id: String, type: String, title: String,content: String, images: [UIImage],complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
    
        var i = 1
        var infoDic:[String: String] = [String: String]()
        for image in images {
            // 压缩图片
            let fileData = UIImageJPEGRepresentation(image, 1)
            let base64String = fileData?.base64EncodedString(options: .endLineWithCarriageReturn)
            let imageName = "baseImg\(i)"
            infoDic[imageName] = base64String ?? ""
            i = i + 1
        }
    
        var parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": open_id,
                                      "type": type,
                                      "title":title,
                                      "content":content]

        for (key, value) in infoDic {
            print(key,value)
            parameters[key] = value
        }
        
        Alamofire.request(kApi_publicTopic, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    //发布社区动态
    class func publishCommunityNetRequest(open_id: String,title: String, images: [UIImage],complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        
        
        var infoArr:[String] = [String]()
        for image in images {
            // 压缩图片
            let fileData = UIImageJPEGRepresentation(image, 1)
            let base64String = fileData?.base64EncodedString(options: .endLineWithCarriageReturn)
            infoArr.append(base64String!)
        }
        
        let str = infoArr.joined(separator: ",")
        
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "uid": open_id,
                                      "base64": str,
                                      "content":title]
            
        Alamofire.request(kApi_publicCommunity, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //个人社区
    class func getPersonCommunityNetRequest(uid: String,mid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,"method": "POST","mid": mid,"uid": uid]
        Alamofire.request(kApi_getPersonCommunity, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //话题评论详情
    class func getTopicCommentDetailNetRequest(pid: String, complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,"method": "POST","pid": pid]
        Alamofire.request(kApi_getTopicCommtentDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //话题回答的评论删除
    class func deleteCommentCommentNetRequest(openId: String, pid: String ,complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id": openId,
                                      "id": pid]
        Alamofire.request(kApi_delCommtentCommentDetail, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //展厅菜单数据
    class func getExhibitionHallMeunNetRequest(type: String,complete: @escaping ((Bool, String?, [NSDictionary]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "category": type]
        Alamofire.request(kApi_getExhibitionHallMeunData, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? [NSDictionary]
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //展厅菜单数据
    class func getMediaListNetRequest(type: String,id: String,complete: @escaping ((Bool, String?, NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "type": type,
                                      "id": id]
        Alamofire.request(kApi_getMediaList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
//                     获取数据
                        let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                        complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //话题推荐达人
    class func getIntelligentListNetRequest(page: String, new_id: String, complete: @escaping ((Bool, String?, [NSDictionary]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "is_login_uid" : AppInfo.shared.user?.userId ?? "",
                                      "page" : page,
                                      "news_id" : new_id]
        Alamofire.request(kApi_IntelligentList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? [NSDictionary]
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //话题推荐好友
    class func invitefriendsListNetRequest(page: String,new_id: String, complete: @escaping ((Bool, String?, [NSDictionary]?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "is_login_uid" : AppInfo.shared.user?.userId ?? "",
                                      "page" : page,
                                      "news_id" : new_id]
        Alamofire.request(kApi_InvitefriendsList, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info, nil)
                } else {
                    let dic = json.dictionary?["data"]?.rawValue as? [NSDictionary]
                    complete(true, info, dic)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //话题邀请回答
    class func inviteFriendsNetRequest(uid: String,new_id: String, complete: @escaping ((Bool, String?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "is_login_uid" : AppInfo.shared.user?.userId ?? "",
                                      "uid" : uid,
                                      "news_id" : new_id]
        Alamofire.request(kApi_Invitefriends, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 400 {
                    complete(false, info)
                } else {
                    complete(true, info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //消息免打扰
    class func ignoreFriendsMessageNetRequest(uid: String, complete: @escaping ((Bool, String?,NSDictionary?) -> Void)) {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "POST",
                                      "open_id" : AppInfo.shared.user?.token ?? "",
                                      "uid" : uid]
        Alamofire.request(kApi_IgnorefriendsMsg, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                let info = json["info"].stringValue
                if code == 200 {
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    complete(true, info, dic)
                } else {
                    complete(false, info,nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
   
    
}

