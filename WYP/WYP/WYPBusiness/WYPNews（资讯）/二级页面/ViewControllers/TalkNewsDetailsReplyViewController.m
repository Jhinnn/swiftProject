//
//  TalkNewsDetailsReplyViewController.m
//  WYP
//
//  Created by Arthur on 2018/1/16.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

#import "TalkNewsDetailsReplyViewController.h"
#import "YYKit.h"
#import "HXPhotoManager.h"
#import "HXPhotoViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Masonry.h"

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


@interface TalkNewsDetailsReplyViewController () <YYTextViewDelegate,HXPhotoViewControllerDelegate>

@property (nonatomic ,strong) UIButton * publishBtn;

@property (nonatomic ,strong) UIView * settingView;


@property (nonatomic, strong) YYTextView *contentTextView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) HXPhotoManager *manager;

@property (nonatomic ,assign)CGFloat navHeight;

@property (nonatomic ,assign)CGFloat keyboardHeight;

@property (nonatomic ,strong)NSMutableArray * imagesArr;    //存放图片
@property (nonatomic ,strong)NSMutableArray * imageUrlsArr; // 存放图片url
@property (nonatomic ,strong)NSMutableArray * desArr;       //存放图片描述
@property (nonatomic ,strong)NSString * contentStr;       // 带有标签的文章内容

@property (nonatomic ,strong)NSMutableArray * imageUrl;       // 带有标签的文章内容

@property (nonatomic ,copy)NSString * isAllow_reply;       // 是否禁止评论  1允许  0 不

@end

@implementation TalkNewsDetailsReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布图文";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navHeight = kDevice_Is_iPhoneX ? 88 : 64;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
  
    self.isAllow_reply = @"1"; //默认可以评论
    
    
    [self setupSubViews];
    
    self.titleLabel.text = self.newsTitle;
    
    
    
}

/**
 设置UI布局
 */
- (void)setupSubViews {
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.publishBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    // 图文正文输入框
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.titleLabel];
    
//    CGRectMake(16, 15, kScreenWidth - 32, 45)

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.view).offset(10);
    }];
    
//    WithFrame:CGRectMake(0, 60, kScreen_width, kScreen_height - 124)
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    
}



/**
 获取键盘高度
 */
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
}



#pragma mark - setter

- (YYTextView *)contentTextView {
    if (!_contentTextView) {
        YYTextView *textView = [[YYTextView alloc] init];
        textView.tag = 1000;
        textView.textContainerInset = UIEdgeInsetsMake(10, 16, 20, 16);
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        textView.scrollIndicatorInsets = textView.contentInset;
        textView.delegate = self;
        textView.placeholderText = @"请写回答内容";
        textView.font = [UIFont systemFontOfSize:17];
        textView.placeholderFont = [UIFont systemFontOfSize:17];
        textView.selectedRange = NSMakeRange(textView.text.length, 0);
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        textView.allowsPasteImage = YES;
        textView.allowsPasteAttributedString = YES;
        textView.typingAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
        textView.inputAccessoryView = [self textViewBar];
        _contentTextView = textView;
    }
    return _contentTextView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)settingView {
    if (!_settingView) {
        _settingView = [[UIView alloc] init];
        _settingView.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1];
        
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        topView.backgroundColor = [UIColor colorWithRed:244/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        [_settingView addSubview:topView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(kScreenWidth - 70, 0, 70, 45);
        [closeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [topView addSubview:closeBtn];
        
      
        UILabel *lineLabel1 = [[UILabel alloc]  initWithFrame:CGRectMake(0, 46, kScreenWidth, 1)];
        lineLabel1.backgroundColor = [UIColor colorWithRed:231/255.0 green:232/255.0 blue:233/255.0 alpha:1];
        [_settingView addSubview:lineLabel1];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 100, 45)];
        titleLabel.text = @"禁止评论";
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_settingView addSubview:titleLabel];
        
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 54, 80, 40)];
        [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [_settingView addSubview:switchBtn];
        
        UILabel *lineLabel2 = [[UILabel alloc]  initWithFrame:CGRectMake(30, 89, kScreenWidth- 60, 1)];
        lineLabel2.backgroundColor = [UIColor colorWithRed:231/255.0 green:232/255.0 blue:233/255.0 alpha:1];
        [_settingView addSubview:lineLabel2];
    
    }
    return  _settingView;
}


#pragma mark  --是否禁止评论
- (void)switchAction:(UISwitch *)sw{
    if (sw.isOn) {  //开启状态  不让评论
        self.isAllow_reply = @"0";
    }else {  //关闭状态 可以评论
        self.isAllow_reply = @"1";
    }
}



- (UIToolbar *)textViewBar {
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    // 空白格
    UIBarButtonItem *spaces = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 关闭箭头
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 28);
    [btn setImage:[UIImage imageNamed:@"answer_icon_jianpan_normal"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeKeyboardAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    // 添加图片
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 30, 28);
    [btn1 addTarget:self action:@selector(selectedImageAction) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"answer_icon_picture_normal"] forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn1];

    // 空白
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 0, 1, 28);
    UIBarButtonItem *center = [[UIBarButtonItem alloc] initWithCustomView:btn3];
    
    // 禁止评论
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 30, 28);
    [btn2 addTarget:self action:@selector(aovidCommonAction) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"answer_icon_prohibit_normal"] forState:UIControlStateNormal];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    bar.items = @[left, spaces, right, center,right1];
    return bar;
}


#pragma mark --禁止评论
- (void)aovidCommonAction {
    
    for(UIView*window in [UIApplication sharedApplication].windows)
    {
        if([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
        {
            self.settingView.frame = CGRectMake(0, kScreenHeight - (self.keyboardHeight), kScreenWidth, self.keyboardHeight + 40);
            [window addSubview:self.settingView];
            
        }else {
            self.settingView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
            
        }
        
    }
    
}

#pragma mark --关闭禁止评论视图
- (void)closeAction {
    [self.settingView removeFromSuperview];
}


#pragma mark --提交评论
- (void)pushCommentAction {
    [self.imagesArr removeAllObjects];
    [self.desArr removeAllObjects];
    [self.imageUrlsArr removeAllObjects];
    
    NSAttributedString *content = self.contentTextView.attributedText;
    
    NSString *text = [self.contentTextView.text copy];
    [content enumerateAttributesInRange:NSMakeRange(0, text.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        YYTextAttachment *att = attrs[@"YYTextAttachment"];
        if (att) {
            if ([att.content isKindOfClass:[YYTextView class]]) {
                YYTextView * textView = att.content;
                [self.desArr addObject:textView.text];
                
            }else{
                
                YYAnimatedImageView *imgView = att.content;
                [self.imagesArr addObject:imgView.image];
            }
            
        }
    }];
    
    self.contentStr = [text stringByReplacingOccurrencesOfString:@"\U0000fffc" withString:@"<我是图片>"];
    
    if (self.imagesArr.count == 0) {
        [self commitContentAction:self.contentStr];
    }else {
        [self upLoadImg:self.imagesArr];
    }
    
    
    
    
}


- (NSArray *)upLoadImg:(NSArray *)arr {
    
    NSMutableArray *imgsArray = [NSMutableArray array];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserInfo"];
    NSString *open_id = dic[@"open_id"];


    for (UIImage *image in arr) {

        NSData *data = UIImageJPEGRepresentation(image, 0.5f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSDictionary *param = @{
                                @"access_token" : @"4170fa02947baeed645293310f478bb4",
                                @"method" : @"POST",
                                @"open_id" : open_id,
                                @"baseImg" : encodedImageStr
                                };
        
        [manager POST:@"http://ald.1001alading.com/api/upload_img" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSDictionary *dic = responseObject[@"data"];
            NSString *url = dic[@"domain_path"];
            
            [imgsArray addObject:url];
            
            if (imgsArray.count == arr.count) {  //全部执行完毕
                _imageUrl = imgsArray;
                NSString *htmlStr = [self makeHtmlString:_imageUrl contentStr:_contentStr];
                [self commitContentAction:htmlStr];
            }
            
            
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 
                 NSLog(@"%@",error);  //这里打印错误信息
                 
        }];
    }

    return nil;

}

- (void)commitContentAction:(NSString *)content {
    
    if (content.length <= 10) {
        [SVProgressHUD showErrorWithStatus:@"回答内容过短"];
        return;
    }
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserInfo"];
    NSString *open_id = dic[@"open_id"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = @{
                            @"access_token" : @"4170fa02947baeed645293310f478bb4",
                            @"method" : @"GET",
                            @"open_id" : open_id,
                            @"id" : self.newsId,
                            @"content" : content,
                            @"allow_reply" : self.isAllow_reply
                            };
    
    [manager POST:@"http://ald.1001alading.com/api/ReGambit" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"感谢你的回答"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        
        [SVProgressHUD showErrorWithStatus:@"无法重复回答该话题"];
        
    }];
    
}


-(UIButton *)publishBtn
{
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBtn.bounds = CGRectMake(0, 0, 40, 44);
        [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(pushCommentAction) forControlEvents:UIControlEventTouchUpInside];
        [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _publishBtn;
}



- (void)setupImage:(UIImage *)image {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTextView.attributedText];
    UIFont *font = [UIFont systemFontOfSize:17];
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    YYImage *img = [YYImage imageWithData:imgData];
    img.preloadAllAnimatedImageFrames = YES;
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.autoPlayAnimatedImage = NO;
    imageView.clipsToBounds = YES;
    [imageView startAnimating];
    CGSize size = imageView.size;
    CGFloat textViewWidth = kScreenWidth - 32.0;
    size = CGSizeMake(textViewWidth, size.height * textViewWidth / size.width);
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:size alignToFont:font alignment:YYTextVerticalAlignmentCenter];

    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    [text insertAttributedString:attachText atIndex:self.contentTextView.selectedRange.location + 1];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" attributes:nil]];
    
    text.font = font;
    self.contentTextView.attributedText = text;
    [self.contentTextView becomeFirstResponder];
    self.contentTextView.selectedRange = NSMakeRange(self.contentTextView.text.length, 0);
    
    [self.view endEditing:NO];
}





-(NSMutableArray *)imageUrlsArr{
    if (!_imageUrlsArr) {
        _imageUrlsArr = [NSMutableArray array];
    }
    return _imageUrlsArr;
}
-(NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}
-(NSMutableArray *)desArr{
    if (!_desArr) {
        _desArr = [NSMutableArray array];
    }
    return _desArr;
}
-(NSMutableArray *)imageUrl{
    if (!_imageUrl) {
        _imageUrl = [NSMutableArray array];
    }
    return _imageUrl;
}

#pragma mark YYTextViewDelegate




- (void)closeKeyboardAction {
    [self.view endEditing:YES];
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = YES;
        _manager.outerCamera = YES;
        
        _manager.showFullScreenCamera = YES;
    }
    return _manager;
}

- (void)selectedImageAction {
    HXPhotoViewController *photoVC = [[HXPhotoViewController alloc] init];
    photoVC.delegate = self;
    photoVC.manager = self.manager;
    [photoVC.manager.endSelectedList removeAllObjects];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:photoVC] animated:YES completion:nil];
}

- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    
    
    for (HXPhotoModel *model in allList) {
        if (model.asset == nil) { //拍摄照片
            [self setupImage:model.previewPhoto];
        }else {
            [HXPhotoTools FetchPhotoForPHAsset:model.asset Size:CGSizeMake(kScreen_width, kScreen_height) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                if (info[@"PHImageFileSandboxExtensionTokenKey"] != nil) {
                    [self setupImage:image];
                }
            }];
        }
        
        
      

        
    }
    
    
   
    
        
        

}

/**
 点击取消执行的代理
 */
- (void)photoViewControllerDidCancel {
    
}


- (NSString *)makeHtmlString:(NSMutableArray *)imageUrlArr contentStr:(NSString *)contentStr{
    NSString * htmlStr = @"";
    //组装图片标签
    NSMutableArray * imgTagArr = [NSMutableArray array];
    for (int i = 0; i < imageUrlArr.count; i ++) {
        NSString * urlStr = imageUrlArr[i];

        NSString *imgTag = [NSString stringWithFormat:@"<img src=\"%@\"><br/>",urlStr];

        [imgTagArr addObject:imgTag];
    }
    
    //组装文字标签 和图片标签
    NSArray * textArr = [contentStr componentsSeparatedByString:@"<我是图片>"];
    for (int i= 0; i < textArr.count; i ++) {
//        NSString * pTag = [[@"<p>" stringByAppendingString:textArr[i]]stringByAppendingString:@""];
        NSString * pTag = [[@"" stringByAppendingString:textArr[i]]stringByAppendingString:@"<br/>"];
        htmlStr = [NSString stringWithFormat:@"%@%@",htmlStr,pTag];
        for (int j = 0; j < imgTagArr.count; j ++) {
            if (i == j) {
                htmlStr = [NSString stringWithFormat:@"%@%@",htmlStr,imgTagArr[j]];
            }
        }
    }
    
//    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<p>\n</p>" withString:@""];
//    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
    NSLog(@"这是转化后的html格式的图文内容----%@",htmlStr);
    return htmlStr;
}




@end
