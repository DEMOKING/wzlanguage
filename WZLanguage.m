//
//  WZLanguage.m
//  WZLanguageTool
//
//  Created by 王亚振 on 2020/12/16.
//

#import "WZLanguage.h"
#import "WZLanguageConstants.h"
#define WZLanguageVersion @"1.0.0"
@interface WZLanguage ()

@property (strong, nonatomic) NSDictionary *datas;

@end

@implementation WZLanguage
+ (WZLanguage *)sharedManager {
    static WZLanguage *sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[WZLanguage alloc] init];
    });
    return sharedManager;
}
- (NSDictionary *)datas {
    if (!_datas) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"WZLanguage" ofType:@"json"];
        if (jsonPath) {
            NSData *data = [NSData dataWithContentsOfFile:jsonPath];
            NSError *error = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                 NSLog(@"\n%@", [error localizedDescription]);
            if (error) {
                NSLog(@"WZLanguage：词条库同步失败");
            }
            if (![result isKindOfClass:[NSDictionary class]]) {
                NSLog(@"WZLanguage：词条库同步失败");
            }
            _datas = result;
        }else {
            NSLog(@"WZLanguage：缺少WZLanguage.json");
        }
    }
    return _datas;
}
/// 获取当前版本
+ (NSString *)currentVersion {
    return WZLanguageVersion;
}
/// 获取当前系统语言
+ (NSString *)currentSystemLanguageString {
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languageArray firstObject];
    return currentLanguage;
}
/// 获取当前Save语言
+ (NSString *)currentLocalLanguageString {
    NSString *localString = [[NSUserDefaults standardUserDefaults] valueForKey:WZLanguageLocalKey];
    return localString;
}
/// 根据当前字符串分类。私有方法
/// @param currentLanguage 字符串
+ (WZLanguageType)currentLanguageWithString:(NSString *)currentLanguage {
    if (![currentLanguage length]) {
        return WZLanguageTypeOther;
    }
    if ([currentLanguage isEqual:@"zh-Hans-CN"]) {
        return WZLanguageTypeZH;
    }else if ([currentLanguage isEqual:@"en-CN"]) {
        return WZLanguageTypeEN;
    }else if ([currentLanguage isEqual:@"en-IN"]) {
        return WZLanguageTypeIN;
    }else if ([currentLanguage isEqual:@"en-AU"]) {
        return WZLanguageTypeAU;
    }else if ([currentLanguage isEqual:@"en-CA"]) {
        return WZLanguageTypeCA;
    }else if ([currentLanguage isEqual:@"en-IE"]) {
        return WZLanguageTypeIE;
    }else if ([currentLanguage isEqual:@"ja-CN"]) {
        return WZLanguageTypeJA;
    }else if ([currentLanguage isEqual:@"ar-CN"]) {
        return WZLanguageTypeAR;
    }else if ([currentLanguage isEqual:@"fr-CN"]) {
        return WZLanguageTypeFR;
    }else if ([currentLanguage isEqual:@"ko-CN"]) {
        return WZLanguageTypeKO;
    }
    else {
        return WZLanguageTypeOther;
    }
}
/// 获取当前系统语言（跟随手机）
+ (WZLanguageType)currentSystemLanguageType {
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languageArray firstObject];
    WZLanguageType type = [WZLanguage currentLanguageWithString:currentLanguage];
    return type;
}
/// 获取当前设置的本地语言（跟随APP，默认为系统语言）
+ (WZLanguageType)currentLocalLanguageType {
    NSString *localString = [[NSUserDefaults standardUserDefaults] valueForKey:WZLanguageLocalKey];
    if ([localString length]) {
        WZLanguageType type = [WZLanguage currentLanguageWithString:localString];
        return type;
    }else {
        return [WZLanguage currentSystemLanguageType];
    }
}
/// 设置本地语言
+ (void)setLocalLanguage:(WZLanguageType)type {
    if(type == WZLanguageTypeZH) {
        [[NSUserDefaults standardUserDefaults] setValue:@"zh-Hans-CN"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeEN) {
        [[NSUserDefaults standardUserDefaults] setValue:@"en-CN"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeIN) {
        [[NSUserDefaults standardUserDefaults] setValue:@"en-IN"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeAU) {
        [[NSUserDefaults standardUserDefaults] setValue:@"en-AU"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeCA) {
        [[NSUserDefaults standardUserDefaults] setValue:@"en-CA"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeIE) {
        [[NSUserDefaults standardUserDefaults] setValue:@"en-IE"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeJA) {
        [[NSUserDefaults standardUserDefaults] setValue:@"ja-CN"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeAR) {
        [[NSUserDefaults standardUserDefaults] setValue:@"ar-CN"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeFR) {
        [[NSUserDefaults standardUserDefaults] setValue:@"fr-CN"
                                                 forKey:WZLanguageLocalKey];
    }else if(type == WZLanguageTypeKO) {
        [[NSUserDefaults standardUserDefaults] setValue:@"ko-CN"
                                                 forKey:WZLanguageLocalKey];
    }else {
        [WZLanguage removeLocalLanguageSetting];
    }
}
/// 移除本地语言设置
+ (void)removeLocalLanguageSetting {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WZLanguageLocalKey];
}
/// 根据key和type获取字符串 无数据时返回空字符串@""
/// @param key key
/// @param type type
+ (NSString *)stringWithKey:(NSString *)key language:(WZLanguageType)type {
    WZLanguage *language = [WZLanguage sharedManager];
    if (!language.datas) {
        return @"";
    }
    NSDictionary *data = language.datas;
    NSDictionary *value = data[key];
    if (!value) {
        return @"";
    }
    NSString *keyString;
    if (type == WZLanguageTypeZH) {
        keyString = WZLanguageJSONKey_ZH;
    }else if (type == WZLanguageTypeEN) {
        keyString = WZLanguageJSONKey_EN;
    }else if (type == WZLanguageTypeIN) {
        keyString = WZLanguageJSONKey_IN;
    }else if (type == WZLanguageTypeAR) {
        keyString = WZLanguageJSONKey_AR;
    }else if (type == WZLanguageTypeFR) {
        keyString = WZLanguageJSONKey_FR;
    }else if (type == WZLanguageTypeJA) {
        keyString = WZLanguageJSONKey_JA;
    }else if (type == WZLanguageTypeKO) {
        keyString = WZLanguageJSONKey_KO;
    }
    if (!keyString) {
        return @"";
    }
    NSString *valueString = value[keyString];
    if (!valueString) {
        return @"";
    }
    return valueString;
}
/// 根据key获取字符串 无数据时返回空字符串@"" key默认取currentLocalLanguageType
/// @param key 获取字符串的key
+ (NSString *)stringWithKey:(NSString *)key {
    return [WZLanguage stringWithKey:key
                            language:[WZLanguage currentLocalLanguageType]];
}
@end

