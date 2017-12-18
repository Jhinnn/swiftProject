//
//  PublicGroupViewController.m
//  HePingNet
//
//  Created by 武思彤 on 2016/12/20.
//  Copyright © 2016年 NGeLB. All rights reserved.
//
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#define kScreen_width UIScreen.mainScreen.bounds.size.width
#define kScreen_height UIScreen.mainScreen.bounds.size.height

#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "PublicGroupViewController.h"
#import "JFImagePickerController.h"
#import "LPlaceholderTextView.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "AFNetwork.h"

@interface PublicGroupViewController ()<JFImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) LPlaceholderTextView *topTextView;//顶部文本输入
@property (nonatomic,strong) NSMutableArray *picIdArr;
@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,strong) NSMutableArray *imageArr;


@end

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation PublicGroupViewController
{
    NSMutableArray *photos;
    UICollectionView *photosList;
    UIButton *addBtn;
    NSMutableArray *photoArr;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.post_topic isEqualToString:@"1"]) {
        self.title = @"发布话题";
    }else{
        self.title = @"发布社区动态";
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    _picIdArr = [NSMutableArray array];
    photos = [[NSMutableArray alloc] init];
    _params = [NSDictionary dictionary];
    _imageArr = [[NSMutableArray alloc] init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(publicButtonAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"common_navback_button_normal_iPhone"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBackButtonAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIScrollView *bgScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:bgScrollView];
    [bgScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
  

    UIView *bgView = [[UIView alloc]init];
    [bgScrollView addSubview:bgView];
    
    //文本输入
    _topTextView = [[LPlaceholderTextView alloc]init];
    _topTextView.font = [UIFont systemFontOfSize:17];
    _topTextView.returnKeyType = UIReturnKeyDone;
    _topTextView.keyboardType = UIKeyboardTypeDefault;
    _topTextView.delegate = self;
    _topTextView.scrollEnabled = YES;
    
    CGFloat  btn_with = 97 * kScreen_width/750;
    CGFloat btn_x= 124* kScreen_width/750 ;
    CGFloat btn_x_x =  17* kScreen_width/750 ;
    
    
    if ([self.post_topic isEqualToString:@"1"]) {
        
//        分类？
        UILabel * class_title = [[UILabel  alloc]init];
        class_title.textColor = [self colorWithHexString:@"666666" alpha:1.0 ];
        class_title.font = [UIFont systemFontOfSize:20] ;
        class_title.text = @"分类";
        class_title.textAlignment = NSTextAlignmentLeft;
        class_title.frame=CGRectMake(15, 0, 54, btn_with);
        [self.view addSubview:class_title];
        
        NSArray  * title_array=[NSArray arrayWithObjects:@"演出文化",@"旅游文化",@"体育文化",@"电影文化",@"会展文化",@"饮食文化", nil];
         for (int a=0; a<6; a++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btn_x_x+btn_x * a, btn_with, btn_with, btn_with)];
            btn.titleLabel.numberOfLines=2;
            [btn setBackgroundImage:[UIImage imageNamed:@"theme_icon_option_normal"] forState:UIControlStateNormal];
            [btn setTintColor:[UIColor blackColor]];
            [btn setTitle:title_array[a] forState:UIControlStateNormal];
             btn.tag=10013+a;
            [bgView addSubview:btn];
        }
        UILabel * class_underline = [[UILabel  alloc]init];
        class_underline.backgroundColor = [self colorWithHexString:@"EAEAEA" alpha:1.0 ];
        class_underline.frame=CGRectMake(26, btn_with*3, kScreen_width-26, 1);
        [bgView addSubview:class_underline];
//        话题？
        UILabel * topic_title = [[UILabel  alloc]init];
        topic_title.textColor = [self colorWithHexString:@"666666" alpha:1.0 ];
        topic_title.font = [UIFont systemFontOfSize:20] ;
        topic_title.text = @"话题";
        topic_title.textAlignment = NSTextAlignmentLeft;
        topic_title.frame=CGRectMake(15, CGRectGetMaxY(class_underline.frame), 54, btn_with);
        [bgView addSubview:topic_title];
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.width.equalTo(kScreen_width);
            //make.height.equalTo(kScreen_height);
        }];
        [_topTextView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(CGRectGetMaxY(topic_title.frame));
            make.top.equalTo(64);
            make.height.equalTo(kScreen_height/3);
        }];
        _topTextView.placeholderText = @"添加描述和配图（选填）";

    }else{
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.width.equalTo(kScreen_width);
            //make.height.equalTo(kScreen_height);
        }];
        [_topTextView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(self.view);
            make.top.equalTo(64);
            make.height.equalTo(kScreen_height/3);
        }];
        _topTextView.placeholderText = @"分享身边对我的新鲜事...";

    }
   
    

  
    [bgView addSubview:_topTextView];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 3;
    NSInteger size = [UIScreen mainScreen].bounds.size.width/4-1;
    if (size%2!=0) {
        size-=1;
    }
    flowLayout.itemSize = CGSizeMake(size, size);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    photosList = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    photosList.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    photosList.scrollIndicatorInsets = photosList.contentInset;
    photosList.delegate = self;
    photosList.dataSource = self;
    photosList.backgroundColor = [UIColor whiteColor];
    photosList.alwaysBounceVertical = NO;
    photosList.alwaysBounceHorizontal = NO;
    photosList.scrollEnabled = NO;
    [bgView addSubview:photosList];
    [photosList makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topTextView);
        make.right.equalTo(_topTextView);
        make.top.equalTo(_topTextView).offset(kScreen_height/3);
        make.height.equalTo(kScreen_height / 3 * 2);
    }];
    
    [photosList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imagePickerCell"];
    
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"common_add_button_normal_iPhone"] forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn addTarget:self action:@selector(switchPhoneOrCamera) forControlEvents:UIControlEventTouchUpInside];
    [photosList addSubview:addBtn];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
        make.top.equalTo(5);
    }];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(photosList.mas_bottom);
    }];
   
}

- (void)switchPhoneOrCamera {
    // 从相册选择
//    [self pickPhotos];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    // 相册页面的出现方式 自下而上显示
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    _imagePickerController.allowsEditing = YES;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
    
    if (buttonIndex == 0) {
        [self selectImageFromCamera];
    } else {
        // 从相册选择
        [self pickPhotos];
    }
}

- (void)selectImageFromCamera
{
    // 获取相机的访问权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //用户已经明确否认了这一照片数据的应用程序访问
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的“设置-隐私-相机”选项中，允许阿拉丁访问您的相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        //设置摄像头模式（拍照，录制视频）为录像模式
        //    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - 发布按钮点击方法
-(void)publicButtonAction{
    
    NSLog(@"%@", _topTextView.text);
    
    self.navigationItem.rightBarButtonItem.enabled = false;
    if (_topTextView.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入最少1个字"];
        self.navigationItem.rightBarButtonItem.enabled = true;
        return;
    }
    if ([self stringContainsEmoji:_topTextView.text]) {
        [SVProgressHUD showErrorWithStatus:@"存在特殊字符"];
        return;
    }
    NSString *picIdStr = [_picIdArr componentsJoinedByString:@","];
//    NSDictionary *dataDic = [NSDictionary dictionaryWithObject:picIdStr forKey:@"attach_ids"];

//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *extraStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    _params = @{@"access_token":@"4170fa02947baeed645293310f478bb4",
                @"method":@"POST",
                @"uid":self.uid,
                @"content":_topTextView.text,
                @"base64":picIdStr};
//    http:ticket.fenxianghulian.com/api/community_release
    [AFNetwork POST:@"http://ald.1001alading.com/api/community_release" parameters:_params success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString * info = responseObject[@"info"];
        if ([code isEqual:@200]) {
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:YES forKey:@"isPublic"];
            [SVProgressHUD showSuccessWithStatus:info];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:info];
        }
        self.navigationItem.rightBarButtonItem.enabled = true;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"您输入的内容含敏感词，请重新输入！"];
        self.navigationItem.rightBarButtonItem.enabled = true;
    }];
    [JFImagePickerController clear];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (photos.count == 0 && _picIdArr.count != 0) {
        return _picIdArr.count;
    }
    return photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagePickerCell" forIndexPath:indexPath];
    if (photos.count > 0) {
        ALAsset *asset = photos[indexPath.row];
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1];
        if (!imgView) {
            imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView.tag = 1;
            [cell addSubview:imgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preview:)];
            [cell addGestureRecognizer:tap];
        }
        cell.tag = indexPath.item;
        [[JFImageManager sharedManager] thumbWithAsset:asset resultHandler:^(UIImage *result) {
            if (cell.tag==indexPath.item) {
                imgView.image = result;
            }
        }];
    } else {
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1];
        if (!imgView) {
            imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView.tag = 1;
            [cell addSubview:imgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preview:)];
            [cell addGestureRecognizer:tap];
        }
        cell.tag = indexPath.item;
        imgView.image = _imageArr[indexPath.row];
    }
    
    return cell;
}

- (void)preview:(UITapGestureRecognizer *)tap{
    UIView *temp = tap.view;
    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithPreviewIndex:temp.tag];
    picker.pickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)pickPhotos{
    // 获取相册的访问权限
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) { dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                {
                    //已获取权限
                    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController: self];
                    picker.pickerDelegate = self;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                    break;
                case PHAuthorizationStatusDenied:
                {
                    //用户已经明确否认了这一照片数据的应用程序访问
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的“设置-隐私-相册”选项中，允许阿拉丁访问您的相册" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                    break;
                case PHAuthorizationStatusRestricted:
                    //此应用程序没有被授权访问的照片数据。可能是家长控制权限
                    break;
                default:
                    //其他。。。
                break;
            }
        });
    }];
    
    switch (authorStatus) {
        case PHAuthorizationStatusAuthorized:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - ImagePicker Delegate

- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    addBtn.frame = CGRectZero;
    [photos removeAllObjects];
    CGFloat wid = (kScreen_width - 9)/4;
    [photos addObjectsFromArray:picker.assets];
    
    photoArr = [NSMutableArray array];
    
    for (UIImage *image in photos) {
        [photoArr addObject:image];
    }
    for (int i =0; i<photoArr.count; i++) {
        ALAsset *asset = photoArr[i];
        ///获取到相册图片
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        //压缩图片方法
        NSData *imageData=UIImageJPEGRepresentation(tempImg, 0.5);
        ///循环获得图片,并将其上传
//        NSString *str1 = @"data:image/jpg;base64,";
        NSString *str2 = [self base64EncodingWithData:imageData];
//        NSString *strr = [str1 stringByAppendingString:str2];

        [_picIdArr addObject:str2];
    }

    if (picker.assets.count<4) {
        [addBtn remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wid * picker.assets.count + 10);
            make.top.equalTo(10);
        }];
    }else
    if ((4<picker.assets.count || picker.assets.count ==4) && picker.assets.count<8) {
        [addBtn remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wid * (picker.assets.count-4) + 10);
            make.top.equalTo(wid + 10);
        }];
        
    }else
    if (picker.assets.count == 8 || picker.assets.count<10) {
        [addBtn remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wid * (picker.assets.count-8) + 10);
            make.top.equalTo(wid *2 + 10 );
        }];
    }

    [photosList reloadData];
    [self imagePickerDidCancel:picker];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    NSLog(@"哈哈哈哈哈");
    
}

- (void)imagePickerController:(JFImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // MARK: - cat
    addBtn.frame = CGRectZero;
    [photos removeAllObjects];
    CGFloat wid = (kScreen_width - 9)/4;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageArr addObject:image];
    //压缩图片方法
    NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
    ///循环获得图片,并将其上传
    NSString *str2 = [self base64EncodingWithData:imageData];
    [_picIdArr addObject:str2];
    
    [addBtn remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wid * _imageArr.count + 10);
        make.top.equalTo(10);
    }];
    [photosList reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"哈哈哈哈哈");
    
}

-(NSString *)base64EncodingWithData:(NSData *)aData
{
    if ([aData length] == 0)
        return @"";
    
    char *characters = malloc((([aData length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [aData length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [aData length])
            buffer[bufferLength++] = ((char *)[aData bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

#pragma mark - textView代理
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //不支持系统表情的输入
    if ([self stringContainsEmoji:text]) {
        if ([self isNineKeyBoard:text] ){
            return YES;
        }
        return NO;
    }
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    if (range.location >= 2000) {
        return NO;
    }else{
        return YES;
    }
}
// 判断是不是九宫格
- (BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

//是否含有表情
- (BOOL)stringContainsEmoji:(NSString *)string
    {
        
        __block BOOL isEomji = NO;
        [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            const unichar hs = [substring characterAtIndex:0];
            // surrogate pair
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        isEomji = YES;
                    }
                }
            } else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                    isEomji = YES;
                } else if (0x2B05 <= hs && hs <= 0x2b07) {
                    isEomji = YES;
                } else if (0x2934 <= hs && hs <= 0x2935) {
                    isEomji = YES;
                } else if (0x3297 <= hs && hs <= 0x3299) {
                    isEomji = YES;
                } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                    isEomji = YES;
                }
                if (!isEomji && substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    if (ls == 0x20e3) {
                        isEomji = YES;
                    }
                }
            }
        }];
        return isEomji;
        
}

-(void)leftBackButtonAction{
    [JFImagePickerController clear];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//颜色十六进制转二进制+
- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    // 删除字符串中的空格
    NSString * colorStr = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([colorStr length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    // 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"0X"]) {
        colorStr = [colorStr substringFromIndex:2];
    }
    
    // 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    // 除去所有开头字符后 再判断字符串长度
    if ([colorStr length] != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //red
    NSString * redStr = [colorStr substringWithRange:range];
    //green
    range.location = 2;
    NSString * greenStr = [colorStr substringWithRange:range];
    //blue
    range.location = 4;
    NSString * blueStr = [colorStr substringWithRange:range];
    
    // Scan values 将十六进制转换成二进制
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redStr] scanHexInt:&r];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&g];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


@end
