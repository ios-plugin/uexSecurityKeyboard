//
//  CustomNumberKeyboard.h
//  EUExCustomKeyboard
//
//  Created by 杨广 on 16/1/13.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomNumberKeyboardDelegate <NSObject>

- (void) numberKeyBoardInput:(NSString*) showStr;
- (void) numberKeyBoardDelete;
- (void) numberKeyBoardFinish;
- (void) numberKeyBoardChange:(CGFloat) tag;
@end
@interface CustomNumberKeyboard : UIImageView
@property(nonatomic, assign) id<CustomNumberKeyboardDelegate> delegate;
@property(nonatomic,strong)  NSString *keyboardDescription;
- (id)initWithFrame:(CGRect)frame keyboardDescription:(NSString*)keyboardDescription;
@end
