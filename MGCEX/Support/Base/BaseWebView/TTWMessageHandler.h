




#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol WKDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface TTWMessageHandler : UIViewController<WKScriptMessageHandler>

@property (weak , nonatomic) id<WKDelegate> delegate;
@end
