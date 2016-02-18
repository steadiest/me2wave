//
//  MWLoginViewController.h
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWLoginViewController : UIViewController<UIWebViewDelegate> {
    
	UIViewController *webViewController;
	NSString *token;
}

- (void)login;
@end
