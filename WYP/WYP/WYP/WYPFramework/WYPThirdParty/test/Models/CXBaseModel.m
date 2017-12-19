//
//  CXBaseModel.m
//  CXWL
//
//  Created by yangbaolong on 16/1/6.
//  Copyright © 2016年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "CXBaseModel.h"

@implementation CXBaseModel

// 自定义初始化方法
- (id)initWithContentDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        // 1.获取映射关系字典
        NSDictionary *keySetAtt = [self valueAndKeyWithContentDic:dic];
        
        // 2.把字典里面的内容写入到对应的属性里面
        for (NSString *key in dic) {
            // 01 获取对应的value
            id value = dic[key];
//            if (<#condition#>) {
//                <#statements#>
//            }
            // 02 获取需要写入属性的名字
            NSString *attName = keySetAtt[key];
            // 03 通过set方法把值写入到属性中
            SEL action = [self getMethodWithAttName:attName];
            // 04判断当前对象是否有这个set方法，如果有就证明当前对象有这个属性
            if ([self respondsToSelector:action]) {
                // 把参数写入到属性中
                [self performSelector:action withObject:value];
            }
        }
    }
    return self; 
}

// 通过属性的名字获取对应的set方法
- (SEL)getMethodWithAttName:(NSString *)attName
{
    /*
        image
        setImage:
     */
    NSString *firstChar = [[attName substringToIndex:1] uppercaseString];
    NSString *endString = [attName substringFromIndex:1];
    NSString *methodName = [NSString stringWithFormat:@"set%@%@:",firstChar,endString];
    return NSSelectorFromString(methodName);
}


// 创建映射关系
- (NSDictionary *)valueAndKeyWithContentDic:(NSDictionary *)dic
{
    /*
        id:123
        image:http://asd
        type:2
     
        字典的key:属性的名字
        id:id
        image:image
        type:type
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *key in dic) {
        // 把字典的key添加到字典里面
        [params setObject:key forKey:key];
    }
    return params;
}

@end
