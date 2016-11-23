//
//  AppDelegate.h
//  WXPayDemo
//
//  Created by Qi Chen on 11/22/16.
//  Copyright © 2016 Qi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<WXApiDelegate> wxApiDelegate;

@end

