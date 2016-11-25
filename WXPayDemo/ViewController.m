//
//  ViewController.m
//  WXPayDemo
//
//  Created by Qi Chen on 11/22/16.
//  Copyright © 2016 Qi Chen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSDictionary *)createDemoWXPayData {
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios"]] returningResponse:nil error:nil] options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *dictionary = @{@"partnerId":dict[@"partnerid"],
                                 @"prepayId":dict[@"prepayid"],
                                 @"nonceStr":dict[@"noncestr"],
                                 @"timeStamp":dict[@"timestamp"],
                                 @"package":dict[@"package"],
                                 @"sign":dict[@"sign"]
                                 };
    return dictionary;
}

- (IBAction)makeWXPay:(UIButton *)sender {
    [self configureWXApiDelegate];
    NSDictionary *dictionary = [self createDemoWXPayData];
    [self makeWXPayWithDictionary:dictionary];
}

- (void)configureWXApiDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.wxApiDelegate = self;
}

- (void)makeWXPayWithDictionary:(NSDictionary *)dictionary {
    if (dictionary[@"partnerId"] && dictionary[@"prepayId"] &&
        dictionary[@"nonceStr"] && dictionary[@"timeStamp"] &&
        dictionary[@"package"] && dictionary[@"sign"]) {
        PayReq* req             = [PayReq new];
        req.partnerId           = dictionary[@"partnerId"];
        req.prepayId            = dictionary[@"prepayId"];
        req.nonceStr            = dictionary[@"nonceStr"];
        req.timeStamp           = [dictionary[@"timeStamp"] intValue];
        req.package             = dictionary[@"package"];
        req.sign                = dictionary[@"sign"];
        [WXApi sendReq:req];
    } else {
        NSLog(@"Wrong format dictionary!");
    }
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass: [PayResp class]]){
        switch(resp.errCode){
            case WXSuccess:
                NSLog(@"成功");
                break;
            case WXErrCodeCommon:
                NSLog(@"普通错误类型");
                break;
            case WXErrCodeUserCancel:
                NSLog(@"用户点击取消并返回");
                break;
            case WXErrCodeSentFail:
                NSLog(@"发送失败");
                break;
            case WXErrCodeAuthDeny:
                NSLog(@"授权失败");
                break;
            case WXErrCodeUnsupport:
                NSLog(@"微信不支持");
                break;
            default:
                NSLog(@"支付失败，retcode=%d", resp.errCode);
                break;
        }
    }
}

@end
