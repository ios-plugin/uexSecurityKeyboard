//
//  PureNumberKeyboard.h
//  EUExCustomKeyboard
//
//  Created by 杨广 on 16/2/18.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PureNumberKeyboardDelegate <NSObject>

- (void) numberKeyBoardInput:(NSString*) showStr;
- (void) numberKeyBoardDelete;
- (void) numberKeyBoardFinish;

@end
@interface PureNumberKeyboard : UIImageView
@property(nonatomic, assign) id<PureNumberKeyboardDelegate> delegate;
@property(nonatomic,strong)  NSString *keyboardDescription;
- (id)initWithFrame:(CGRect)frame keyboardDescription:(NSString*)keyboardDescription;
@end
