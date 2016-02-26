//
//  CustomBigCharKeyboard.h
//  EUExCustomKeyboard
//
//  Created by 杨广 on 16/2/18.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomBigCharKeyboardDelegate <NSObject>
- (void) numberKeyBoardInput:(NSString*) showStr;
- (void) numberKeyBoardDelete;
- (void) numberKeyBoardFinish;
- (void) numberKeyBoardChange:(CGFloat) tag;
@end
@interface CustomBigCharKeyboard : UIImageView
@property(nonatomic, assign) id<CustomBigCharKeyboardDelegate> delegate;
@property(nonatomic,strong)  NSString *keyboardDescription;
- (id)initWithFrame:(CGRect)frame keyboardDescription:(NSString*)keyboardDescription;
@end
