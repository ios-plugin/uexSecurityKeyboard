//
//  EUExSecurityKeyboard.m
//  EUExSecurityKeyboard
//
//  Created by 杨广 on 16/2/19.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "EUExSecurityKeyboard.h"
#import "EUtility.h"
#import "JSON.h"

@implementation EUExSecurityKeyboard
-(id)initWithBrwView:(EBrowserView *) eInBrwView {
    if (self = [super initWithBrwView:eInBrwView]) {
        self.keyboardType = 0;
        _keyDict = [NSMutableDictionary dictionary];
    }
    return self;
}
-(CustomNumberKeyboard*)numberKeyboardView{
    if (!_numberKeyboardView) {
        _numberKeyboardView = [[CustomNumberKeyboard alloc]initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight]/2.62) keyboardDescription:self.keyboardDescription];
        _numberKeyboardView.delegate = self;
        
    }
    return _numberKeyboardView;
}
-(CustomCharKeyboard*)charKeyboardView{
    if (!_charKeyboardView) {
        _charKeyboardView = [[CustomCharKeyboard alloc]initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight]/2.62) keyboardDescription:self.keyboardDescription];
        _charKeyboardView.delegate = self;
        
    }
    return _charKeyboardView;
}
-(CustomBigCharKeyboard*)bigCharKeyboardView{
    if (!_bigCharKeyboardView) {
        _bigCharKeyboardView = [[CustomBigCharKeyboard alloc]initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight]/2.62) keyboardDescription:self.keyboardDescription];
        _bigCharKeyboardView.delegate = self;
        
    }
    return _bigCharKeyboardView;
}
-(SymbolKeyboard*)symbolKeyboardView{
    if (!_symbolKeyboardView) {
        _symbolKeyboardView = [[SymbolKeyboard alloc]initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight]/2.62) keyboardDescription:self.keyboardDescription];
        _symbolKeyboardView.delegate = self;
        
    }
    return _symbolKeyboardView;
}
-(PureNumberKeyboard*)pureNumberKeyboardView{
    if (!_pureNumberKeyboardView) {
        _pureNumberKeyboardView = [[PureNumberKeyboard alloc]initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight]/2.62) keyboardDescription:self.keyboardDescription];
        _pureNumberKeyboardView.delegate = self;
        
    }
    return _pureNumberKeyboardView;
}

-(void)open:(NSMutableArray *)inArguments {
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
        self.jsonDict = [jsonStr JSONValue];//将JSON类型的字符串转化为可变字典
    }else{
        return;
    }
    float tag = [[self.jsonDict objectForKey:@"id"] floatValue];
    float x = [[self.jsonDict objectForKey:@"x"] floatValue];
    float y = [[self.jsonDict objectForKey:@"y"] floatValue];
    float width = [[self.jsonDict objectForKey:@"width"] floatValue];
    float height = [[self.jsonDict objectForKey:@"height"] floatValue];
    self.keyboardDescription = [self.jsonDict objectForKey:@"keyboardDescription"] ;
    self.keyboardType = [[self.jsonDict objectForKey:@"keyboardType"] intValue];
     UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(x, y, width, height)];
    
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    
    [_keyDict setObject:textField forKey:[NSString stringWithFormat:@"%f",tag]];
    NSLog(@"字典:%@",_keyDict);
    NSMutableArray *keys = [NSMutableArray array];
    [keys addObject:[NSString stringWithFormat:@"%f",tag]];
    self.textField = [_keyDict objectForKey:[keys lastObject]];
    self.textField.tag = [[keys lastObject] intValue];
    [EUtility brwView:meBrwView addSubview:self.textField];
    if (self.keyboardType == 0) {
        self.textField.inputView = self.pureNumberKeyboardView;
    }
    if (self.keyboardType == 1) {
        self.textField.inputView = self.numberKeyboardView;
    }
    self.textField.delegate = self;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
        NSArray *keys = [_keyDict allKeys];
        for (NSString *str in keys) {
            if (textField.tag == [str intValue] ) {
               self.textField = [_keyDict objectForKey:str];
            }
        }

    
}
- (void)numberKeyBoardInput:(NSString*) showStr
{

    NSMutableString *textString = [[NSMutableString alloc] initWithFormat:@"%@%@",self.textField.text,showStr] ;
    self.textField.text = textString;
}
- (void)numberKeyBoardDelete
{
    NSMutableString* mutableString = [[NSMutableString alloc] initWithFormat:@"%@", self.textField.text] ;
    if ([mutableString length] > 0) {
        NSRange tmpRange;
        tmpRange.location = [mutableString length] - 1;
        tmpRange.length = 1;
        [mutableString deleteCharactersInRange:tmpRange];
    }
    self.textField.text = mutableString;
}

- (void)numberKeyBoardFinish
{
    
    [self.textField resignFirstResponder];
    
}
- (void)numberKeyBoardChange:(CGFloat) tag
{
    if (tag == 10) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.charKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 128 ) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.numberKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 131 ) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.symbolKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 126 ) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.bigCharKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 226) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.charKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 228) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.numberKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 231 ) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.symbolKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 338) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.numberKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 339) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        [EUtility brwView:meBrwView addSubview:self.textField];
        self.textField.inputView = self.self.charKeyboardView;
        [self.textField becomeFirstResponder];
    }
    
}

-(void)close:(NSMutableArray *)inArguments {
     if (inArguments.count > 0) {
         NSString * idStr = [inArguments objectAtIndex:0];
         NSArray* idArr = [idStr JSONValue];
         for (NSNumber *num in idArr) {
             NSString *numStr = [NSString stringWithFormat:@"%f",[num floatValue]];
                 self.textField = [_keyDict objectForKey:numStr];
                 self.textField.inputView = nil;
                 [self.textField removeFromSuperview];
             
         }
         
     }else{
         NSArray *keys = [_keyDict allKeys];
         for (NSString *str in keys) {
             self.textField = [_keyDict objectForKey:str];
             self.textField.inputView = nil;
             [self.textField removeFromSuperview];
         }
     }
    
    
}
-(void)getContent:(NSMutableArray *)inArguments {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    NSString *contentStr = nil;
    if (inArguments.count > 0) {
        NSString * idStr = [inArguments objectAtIndex:0];
        NSArray* idArr = [idStr JSONValue];
        for (NSNumber *num in idArr) {
            NSString *numStr = [NSString stringWithFormat:@"%f",[num floatValue]];
            self.textField = [_keyDict objectForKey:numStr];
            [contentDic setObject:self.textField.text forKey:numStr];
            contentStr = [contentDic JSONFragment];
        }
        
    }else{
        NSArray *keys = [_keyDict allKeys];
        for (NSString *str in keys) {
            self.textField = [_keyDict objectForKey:str];
            [contentDic setObject:self.textField.text forKey:str];
            contentStr = [contentDic JSONFragment];

        }
    }
    NSString *jsString = [NSString stringWithFormat:@"uexSecurityKeyboard.cbGetContent('%@');",contentStr];
    [EUtility brwView:meBrwView evaluateScript:jsString];
}
@end
