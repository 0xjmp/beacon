//
//  SSocialManager.h
//  Beacon
//
//  Created by Jake Peterson on 11/1/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SCSocialTypeFacebook,
    SCSocialTypeTwitter,
    SCSocialTypeInstagram,
    SCSocialTypeLinkedIn,
    SCSocialTypeTumblr
} SCSocialType;

typedef void(^SCSocialBlock)(BOOL success);

@interface SSocialManager : NSObject

+ (SSocialManager *)singleton;

+ (BOOL)isSetup:(SCSocialType)socialType;

- (void)attemptOAuth:(SCSocialType)socialType
     completionBlock:(SCSocialBlock)block;

#pragma mark UIApplication
- (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

- (void)applicationDidBecomeActive;

#pragma mark Social Type Helpers
+ (NSString *)nameForSocialType:(SCSocialType)type;
@end
