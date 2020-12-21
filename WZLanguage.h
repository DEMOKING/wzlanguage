//
//  WZLanguage.h
//  WZLanguageTool
//
//  Created by 王亚振 on 2020/12/16.
//

#import <Foundation/Foundation.h>
#import "WZLanguageHeader.h"
#import "WZLanguageENUM.h"
#import "WZLanguageConstants.h"
NS_ASSUME_NONNULL_BEGIN

#define StringKey(__key__) [WZLanguage stringWithKey:__key__]

@interface WZLanguage : NSObject
/// 获取当前版本
+ (NSString *)currentVersion;
/// 获取当前系统语言
+ (NSString *)currentSystemLanguageString;
/// 获取当前Save语言
+ (NSString *)currentLocalLanguageString;
/// 获取当前系统语言（跟随手机）
+ (WZLanguageType)currentSystemLanguageType;
/// 获取当前设置的本地语言（跟随APP，默认为系统语言）
+ (WZLanguageType)currentLocalLanguageType;
/// 设置本地语言
+ (void)setLocalLanguage:(WZLanguageType)type;
/// 移除本地语言设置
+ (void)removeLocalLanguageSetting;
/// 根据key和type获取字符串 无数据时返回空字符串@""
/// @param key key
/// @param type type
+ (NSString *)stringWithKey:(NSString *)key language:(WZLanguageType)type;
/// 根据key获取字符串 无数据时返回空字符串@"" key默认取currentLocalLanguageType
/// @param key 获取字符串的key
+ (NSString *)stringWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
