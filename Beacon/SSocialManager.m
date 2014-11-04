//
//  SSocialManager.m
//  Beacon
//
//  Created by Jake Peterson on 11/1/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

#import "SSocialManager.h"
#import <Beacon-Swift.h>

@interface SSocialManager ()
@property (nonatomic) SCSocialType socialType;
@property (strong, nonatomic) SCSocialBlock completionBlock;
@end

@implementation SSocialManager

static SSocialManager *_sharedManager = nil;

+ (SSocialManager *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SSocialManager alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - Getters

+ (BOOL)isSetup:(SCSocialType)socialType {
    NSDictionary *urls = [SCUser currentUser].socialUrls;
    return urls[[self nameForSocialType:socialType]] != nil;
}

+ (NSString *)nameForSocialType:(SCSocialType)type {
    switch (type) {
        case SCSocialTypeFacebook:
            return @"facebook";

        case SCSocialTypeTwitter:
            return @"twitter";
            
        case SCSocialTypeInstagram:
            return @"instagram";
            
        case SCSocialTypeLinkedIn:
            return @"linkedIn";
            
        case SCSocialTypeTumblr:
            return @"tumblr";

    }
    
    return nil;
}

#pragma mark - Actions

- (void)attemptOAuth:(SCSocialType)socialType
     completionBlock:(SCSocialBlock)block {
    self.socialType = socialType;
    self.completionBlock = block;
    
    NSString *base = [[SCNetworking shared].baseUrl stringByReplacingOccurrencesOfString:@"/v1/" withString:@""];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/auth/%@?id=%@", base, [self.class nameForSocialType:socialType], [SCUser currentUser].objectId.stringValue]];
    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    if ([url.scheme isEqualToString:@"beacon"]) {
        if (url.host.length > 2) {
            NSString *provider = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSNumber *setup = SCUser.currentUser.socialUrls[provider];
            if (self.completionBlock) self.completionBlock(setup.boolValue);
            self.completionBlock = nil;
        }
    }
    
    return YES;
}

- (void)applicationDidBecomeActive {
    if (self.completionBlock) self.completionBlock(NO);
    self.completionBlock = nil;
}

- (void)reloadUserProfile {
    [SCUser getProfile:nil];
}

@end
