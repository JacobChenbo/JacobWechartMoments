//
//  CommonUtils.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/22.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "CommonUtils.h"
#import<CommonCrypto/CommonDigest.h>

@implementation CommonUtils

+ (NSString *)MD5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
