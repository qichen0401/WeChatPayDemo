# WeChatPayDemo

1. Project -> TARGETS -> Info -> URL Types -> Identifier, URL Schemes
2. Project -> TARGETS -> Build Settings -> Other Linker Flags -> -Objc -all_load
3. Project -> TARGETS -> Build Phases -> Link Binary With Libraries
CFNetwork.framework
CoreTelephony.framework
SystemConfiguration.framework
libc++.tbd
libsqlite3.0.tbd
libz.tbd
4. Import WeChatSDK
5. info.plist
<key>LSApplicationQueriesSchemes</key>
<array>
<string>weixin</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
6. AppDelegate.m

[WXApi registerApp:@"wxb4ba3c02aa476ea1" withDescription:@"demo 2.0"];

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([WXApi handleOpenURL:url delegate:self.wxApiDelegate]) {
        return true;
    }
    return false;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([WXApi handleOpenURL:url delegate:self.wxApiDelegate]) {
        return true;
    }
    return false;
}

7. 
<WXApiDelegate>

AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
appDelegate.wxApiDelegate = self;

PayReq* req = [[PayReq alloc] init];
req.partnerId	= …;
req.prepayId	= …;
req.nonceStr	= …;
req.timeStamp	= …;
req.package	= …;
req.sign	= …;
[WXApi sendReq:req];

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
