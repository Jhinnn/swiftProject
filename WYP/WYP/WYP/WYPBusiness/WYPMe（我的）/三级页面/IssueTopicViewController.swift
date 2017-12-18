//
//  IssueTopicViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol IssueTopicViewControllerDelegate {
    func issueTopicsSuccess()
}

class IssueTopicViewController: BaseViewController {

    var delegate: IssueTopicViewControllerDelegate! = nil
    var iamgeArray = NSMutableArray()

    @IBOutlet weak var show_btn: UIButton!
    @IBOutlet weak var tour_btn: UIButton!
    @IBOutlet weak var sports_btn: UIButton!
    @IBOutlet weak var filrm_btn: UIButton!
    @IBOutlet weak var Exhibition_btn: UIButton!
    @IBOutlet weak var food_btn: UIButton!
    @IBOutlet weak var add_image: UIButton!
    @IBOutlet weak var add_image_title: UIButton!

    @IBOutlet weak var textView: UITextView!

    var typeIdStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let releaseBtn = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(releaseDynamic))
        navigationItem.rightBarButtonItem = releaseBtn
        textView.placeholder = "添加描述和配图（选填）"
        add_classview()
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    deinit {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    func add_classview(){
        let btn_with: CGFloat = 97/750 * UIScreen.main.bounds.size.width
        let class_title = UILabel ()
        class_title.textColor = UIColor.init(hexColor: "666666")
        class_title.font = UIFont.systemFont(ofSize: 20)
        class_title.text = "分类"
        class_title.textAlignment = .left
        class_title.frame=CGRect(x: 15 , y: 0, width: 54, height: btn_with)
        self.view .addSubview(class_title)
        
        add_btn(show_btn ,0)
        add_btn(tour_btn ,1)
        add_btn(sports_btn ,2)
        add_btn(filrm_btn ,3)
        add_btn(Exhibition_btn ,4)
        add_btn(food_btn ,5)
        typeButtonAction(show_btn)
        let class_underline = UILabel ()
        class_underline.backgroundColor = UIColor.init(hexColor: "EAEAEA")
        class_underline.frame=CGRect(x:26 , y: btn_with + btn_with + btn_with, width: UIScreen.main.bounds.size.width-26, height: 1)
        self.view .addSubview(class_underline)
        
        let topic_title = UILabel ()
        topic_title.textColor = UIColor.init(hexColor: "666666")
        topic_title.font = UIFont.systemFont(ofSize: 20)
        topic_title.text = "话题"
        topic_title.textAlignment = .left
        topic_title.frame=CGRect(x: 15 , y:  class_underline.frame.origin.y   , width: 54, height: btn_with)
        self.view .addSubview(topic_title)
        textView.frame = CGRect(x: 26, y:  class_underline.frame.size.height+class_underline.frame.origin.y+btn_with , width: UIScreen.main.bounds.size.width - 26 - 26, height: 80)
//
        let iconImage = UIImage(named:"notice_icon_add_normal")?.withRenderingMode(.alwaysOriginal)
        add_image.setImage(iconImage, for:.normal)  //设置图标
        add_image_title.setTitleColor(UIColor.darkGray, for:.normal)
        setupImageUIFrame()
        
        
    }
    // 设置选择图片按钮的位置
    
    func setupImageUIFrame() {
        let btn_frame_x: CGFloat =   CGFloat(iamgeArray.count * 97)
        let btn_frame_height: CGFloat =  97/750 * UIScreen.main.bounds.size.width

       add_image.frame=CGRect(x: btn_frame_x + 30 , y:  textView.frame.size.height+textView.frame.origin.y+10 , width: btn_frame_height , height: btn_frame_height)
        add_image_title.frame = CGRect(x: btn_frame_x + btn_frame_height + 40 , y:  textView.frame.size.height+textView.frame.origin.y+10 , width: btn_frame_height + btn_frame_height + btn_frame_height + btn_frame_height, height: btn_frame_height)
//        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_editorGary_button_normal_iPhone"), style: .done, target: self, action: #selector(goToUserQR))
//        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    // 添加btn
     func add_btn (_ btn: UIButton ,_ index: Int) {
        let btn_with: CGFloat = 97/750 * UIScreen.main.bounds.size.width
        let btn_x: CGFloat = 124/750 * UIScreen.main.bounds.size.width
        let btn_x_x: CGFloat =  17/750 * UIScreen.main.bounds.size.width
        btn.frame=CGRect(x: floor(btn_x_x+btn_x * CGFloat(index)) , y: btn_with, width: btn_with, height: btn_with)
        btn.titleLabel?.numberOfLines=2
        
        btn_background_titleColor(btn)
        
    }
    //让分类内的btn背景重置
    func btn_background_titleColor (_ btn: UIButton ) {
        let iconImage = UIImage(named:"theme_icon_option_normal")?.withRenderingMode(.alwaysOriginal)
        btn.setBackgroundImage(iconImage, for:.normal)  //设置图标
        btn.setTitleColor(UIColor.black, for:.normal)
        
    }
    // MARK: - event response
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height - 200
        let animations:(() -> Void) = {
            if deviceTypeIphone5() || deviceTypeIPhone4() {
                //键盘的偏移量
                self.textView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
            }
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        self.textView.transform = CGAffineTransform(translationX: 0 , y: 0)
    }
    //设置分类按钮背景颜色
    @IBAction func typeButtonAction(_ sender: UIButton) {
      
        btn_background_titleColor(show_btn)
        btn_background_titleColor(tour_btn)
        btn_background_titleColor(sports_btn)
        btn_background_titleColor(filrm_btn)
        btn_background_titleColor(Exhibition_btn)
        btn_background_titleColor(food_btn)
        
        //设置图标
        //lastButton?.backgroundColor = UIColor.init(hexColor: "#D3D7D8")
        // 设置新的选中按钮的背景颜色
        let iconImage_a = UIImage(named:"theme_icon_option_pitch")?.withRenderingMode(.alwaysOriginal)
        sender.setBackgroundImage(iconImage_a, for:.normal)
        sender.setTitleColor(.white, for: .normal)
        typeIdStr = "\(sender.tag - 200)"
    }
//    发布话题请求数据
    func releaseDynamic() {
//        UserDefaults.standard.set(AppInfo.shared.user?.token ?? "", forKey: "token")
//        let releaseVC = PublicGroupViewController()
//        releaseVC.userToken = AppInfo.shared.user?.token ?? ""
//        releaseVC.uid = AppInfo.shared.user?.userId ?? ""
//        navigationController?.pushViewController(releaseVC, animated: true)
    }
    @IBAction func issueButtonAction(_ sender: UIButton) {
//        if textView.text.characters.count > 100 {
//            SVProgressHUD.showError(withStatus: "内容过多，请控制在50字以内")
//            return
//        } else if textView.text.characters.count < 1 {
//            SVProgressHUD.showError(withStatus: "内容不能为空")
//            return
//        }
        // 13:演出文化 14:旅游文化 15:体育文化 16:电影文化 17:会展文化 18:饮食文化
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.issueTopicNetRequest(token: token, typeId: typeIdStr, text: textView.text) { (success, info) in
            if success {
                // 发布成功
                self.delegate?.issueTopicsSuccess()
                SVProgressHUD.showSuccess(withStatus: info)
                self.navigationController?.popViewController(animated: true)
            } else {
                // 发布失败
                SVProgressHUD.showError(withStatus: info)
            }
//            Integer
        }
    }
    
     @IBAction func imageButtonAction(_ sender: UIButton) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消",    destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册选择")
        actionSheet.tag = 101
        actionSheet.show(in: view)
    }
    //设置控件
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.modalTransitionStyle = .coverVertical
        // 设置是否可以管理已经存在的图片或者视频
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension IssueTopicViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension IssueTopicViewController: UIActionSheetDelegate {
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
       
        
            // 选择头像
            switch buttonIndex {
            case 2:
                // 相册选择
                getImageFromPhotoLib(type: .photoLibrary)
            case 1:
                // 相机拍照
                getImageFromPhotoLib(type: .camera)
            default:
                // 取消
                break
            }
       
    }
    
    // 开启相机相册
    func getImageFromPhotoLib(type: UIImagePickerControllerSourceType) {
        imagePickerController.sourceType = type
        // 判断是否支持相册
        if UIImagePickerController.isSourceTypeAvailable(type) {
            self.present(imagePickerController, animated: true, completion: {
                self.imagePickerController.delegate = self
            })
        }
    }
}

extension IssueTopicViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 关闭当前相册视图控制器
        picker.dismiss(animated: true, completion: nil)
        
        let image = info["UIImagePickerControllerEditedImage"] as! UIImage
        iamgeArray .add(image)
        print(iamgeArray.count)
        
//        // 压缩图片
//        let fileData = UIImageJPEGRepresentation(image, 0.4)
//        let base64String = fileData?.base64EncodedString(options: .endLineWithCarriageReturn)
//
//        let infoDic = ["baseImg": base64String ?? ""]
//        netRequestAction(infoDic: infoDic)
    }
}
