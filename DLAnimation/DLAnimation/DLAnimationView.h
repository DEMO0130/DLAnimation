//
//  DLAnimationView.h
//  DLAnimation
//
//  Created by DEMO on 16/3/7.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLAnimationView : UIView
@property (nonatomic, copy) void (^completionBlock)();

- (void)setUpOrigin;
@end
