//
//  EUExSecurityKeyboard.h
//  EUExSecurityKeyboard
//
//  Created by 杨广 on 16/2/19.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUExBase.h"
#import <UIKit/UIKit.h>
#import "CustomNumberKeyboard.h"
#import "CustomCharKeyboard.h"
#import "PureNumberKeyboard.h"
#import "CustomBigCharKeyboard.h"
#import "SymbolKeyboard.h"
@interface EUExSecurityKeyboard :EUExBase<CustomNumberKeyboardDelegate, CustomCharKeyboardDelegate,PureNumberKeyboardDelegate,CustomBigCharKeyboardDelegate,SymbolKeyboardDelegate,UITextFieldDelegate>
@property(nonatomic,retain) NSMutableDictionary *jsonDict;
@property(nonatomic,retain) NSMutableDictionary *keyDict;
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) NSString *keyboardDescription;
@property int keyboardType;
@property(nonatomic,strong)CustomNumberKeyboard *numberKeyboardView;
@property(nonatomic,strong)CustomCharKeyboard *charKeyboardView;
@property(nonatomic,strong)PureNumberKeyboard *pureNumberKeyboardView;
@property(nonatomic,strong)CustomBigCharKeyboard *bigCharKeyboardView;
@property(nonatomic,strong)SymbolKeyboard *symbolKeyboardView;
@end

