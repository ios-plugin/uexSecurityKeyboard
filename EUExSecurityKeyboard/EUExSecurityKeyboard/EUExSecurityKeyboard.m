//
//  EUExSecurityKeyboard.m
//  EUExSecurityKeyboard
//
//  Created by 杨广 on 16/2/19.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "EUExSecurityKeyboard.h"
#import "EUtility.h"

static inline NSString * newUUID(){
    return [NSUUID UUID].UUIDString;
}
@implementation EUExSecurityKeyboard
//-(id)initWithBrwView:(EBrowserView *) eInBrwView {
//    if (self = [super initWithBrwView:eInBrwView]) {
//        self.keyboardType = 0;
//        _keyDict = [NSMutableDictionary dictionary];
//    }
//    return self;
//}
-(id)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine{
    if (self = [super initWithWebViewEngine:engine]) {
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

-(NSString*)open:(NSMutableArray *)inArguments {
    ACArgsUnpack(NSDictionary *dic) = inArguments;
    if (dic == nil) {
        return nil;
    }
    NSString *idStr = stringArg(dic[@"id"]) ?: newUUID();
    if ([_keyDict objectForKey:idStr]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSArray *keys = [_keyDict allKeys];
//            for (NSString *str in keys) {
//                if ([str isEqualToString:idStr]) {
//                    
//                }
//                CustomUITextField *textFieldOff = [_keyDict objectForKey:str];
//                [textFieldOff resignFirstResponder];
//            }
            
            self.textField = [_keyDict objectForKey:idStr];
            [self.textField becomeFirstResponder];
        });
        return nil;
    }
    float x = [numberArg(dic[@"x"]) floatValue];
    float y = [numberArg(dic[@"y"]) floatValue];
    float width = [numberArg(dic[@"width"]) floatValue];
    float height = [numberArg(dic[@"height"]) floatValue];
    BOOL isScroll = [dic[@"isScrollWithWeb"] boolValue];
    
    self.isShowInputBox = YES;
    if (dic[@"showInputBox"] != nil) {
        BOOL isShowInputBox = [dic[@"showInputBox"] boolValue];
        if (!isShowInputBox) {
            self.isShowInputBox = NO;
        }
    }
    
    self.keyboardDescription = stringArg(dic[@"keyboardDescription"]);
    self.keyboardType = [numberArg(dic[@"keyboardType"]) intValue];
    
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CustomUITextField* textField = [[CustomUITextField alloc]initWithFrame:CGRectMake(x, y, width, height)];
        
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        
        [_keyDict setObject:textField forKey:idStr];
        NSLog(@"字典:%@",_keyDict);
        NSMutableArray *keys = [NSMutableArray array];
        [keys addObject:idStr];
        self.textField = [_keyDict objectForKey:[keys lastObject]];
        self.textField.idStr = [keys lastObject];
        self.textField.isShowInputBox = self.isShowInputBox;
        
        if (self.isShowInputBox == NO) {
            self.textField.frame = CGRectMake(x-2000, y-2000, width, height);
        }
        
        if (isScroll) {
            [[self.webViewEngine webScrollView] addSubview:self.textField];
        } else {
            [[self.webViewEngine webView] addSubview:self.textField];
        }
        
        if (self.keyboardType == 1) {
            self.textField.inputView = self.numberKeyboardView;
        }
        else if (self.keyboardType == 2) {
            
        }else{
            self.textField.inputView = self.pureNumberKeyboardView;
        }
        self.textField.delegate = self;
        
        [self.textField becomeFirstResponder];
    });
    
    return idStr;
}
- (void)textFieldDidBeginEditing:(CustomUITextField *)textField{
    NSArray *keys = [_keyDict allKeys];
    for (NSString *str in keys) {
        if ([textField.idStr isEqual:str]) {
            self.textField = [_keyDict objectForKey:str];
        }
    }
    
    
}
- (void)numberKeyBoardInput:(NSString*)showStr
{
    
    NSMutableString *textString = [[NSMutableString alloc] initWithFormat:@"%@%@",self.textField.text,showStr] ;
    self.textField.text = textString;
    
    if (self.textField.isShowInputBox == NO) {
        NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:showStr,@"inputData",@0,@"inputType",self.textField.idStr,@"id", nil];
        NSString *resultStr = [resultDic ac_JSONFragment];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSecurityKeyboard.onKeyPress" arguments:ACArgsPack(resultStr)];
    }
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
    
    if (self.textField.isShowInputBox == NO) {
        NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"inputType",self.textField.idStr,@"id", nil];
        NSString *resultStr = [resultDic ac_JSONFragment];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSecurityKeyboard.onKeyPress" arguments:ACArgsPack(resultStr)];
    }
}

- (void)numberKeyBoardFinish
{
    
    [self.textField resignFirstResponder];
    
    if (self.textField.isShowInputBox == NO) {
        NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:@2,@"inputType",self.textField.idStr,@"id", nil];
        NSString *resultStr = [resultDic ac_JSONFragment];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSecurityKeyboard.onKeyPress" arguments:ACArgsPack(resultStr)];
    }
}
- (void)numberKeyBoardChange:(CGFloat)tag
{
    if (tag == 10) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.charKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 128 ) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.numberKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 131 ) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.symbolKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 126 ) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.bigCharKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 226) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.charKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 228) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.numberKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 231 ) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.symbolKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 338) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.numberKeyboardView;
        [self.textField becomeFirstResponder];
    }
    if (tag == 339) {
        self.textField.inputView = nil;
        [self.textField removeFromSuperview];
        //[EUtility brwView:meBrwView addSubview:self.textField];
         [[self.webViewEngine webView] addSubview:self.textField];
        self.textField.inputView = self.self.charKeyboardView;
        [self.textField becomeFirstResponder];
    }
    
}

-(void)close:(NSMutableArray *)inArguments {
    
    if (inArguments.count > 0) {
        NSArray *idArr = ac_arrayArg(inArguments[0]);
        if (idArr) {
            ACArgsUnpack(NSArray* idArr) = inArguments;
            for (id num in idArr) {
                NSString *numStr = stringArg(num);
                CustomUITextField *textField = [_keyDict objectForKey:numStr];
                textField.inputView = nil;
                [textField removeFromSuperview];
                [_keyDict removeObjectForKey:numStr];
            }
        }else{
            ACArgsUnpack(NSString* numStr) = inArguments;
            CustomUITextField *textField = [_keyDict objectForKey:numStr];
            textField.inputView = nil;
            [textField removeFromSuperview];
            [_keyDict removeObjectForKey:numStr];
        }
        
        
    }else{
        NSArray *keys = [_keyDict allKeys];
        for (NSString *str in keys) {
            self.textField = [_keyDict objectForKey:str];
            self.textField.inputView = nil;
            [self.textField removeFromSuperview];
        }
        [_keyDict removeAllObjects];
    }
    
    
//    if (inArguments.count > 0) {
//        NSArray *idArr = ac_arrayArg(inArguments[0]);
//        if (idArr) {
//            ACArgsUnpack(NSArray* idArr) = inArguments;
//            for (id num in idArr) {
//                NSString *numStr = stringArg(num);
//                self.textField = [_keyDict objectForKey:numStr];
//                self.textField.inputView = nil;
//                [self.textField removeFromSuperview];
//                [_keyDict removeObjectForKey:numStr];
//            }
//        }else{
//            ACArgsUnpack(NSString* numStr) = inArguments;
//            self.textField = [_keyDict objectForKey:numStr];
//            self.textField.inputView = nil;
//            [self.textField removeFromSuperview];
//            [_keyDict removeObjectForKey:numStr];
//        }
//        
//        
//    }else{
//        NSArray *keys = [_keyDict allKeys];
//        for (NSString *str in keys) {
//            self.textField = [_keyDict objectForKey:str];
//            self.textField.inputView = nil;
//            [self.textField removeFromSuperview];
//        }
//        [_keyDict removeAllObjects];
//    }
    
    
}
-(NSArray*)getContent:(NSMutableArray *)inArguments {
    NSDictionary *contentDic = [NSDictionary dictionary];
    NSMutableArray *contentArr = [NSMutableArray array];
    NSString *contentStr = nil;
    if (inArguments.count > 0) {
        NSArray *idArr = ac_arrayArg(inArguments[0]);
        if (idArr) {
            ACArgsUnpack(NSArray* idArr) = inArguments;
            for (id num in idArr) {
                NSString *numStr = stringArg(num);
                self.textField = [_keyDict objectForKey:numStr];
                contentDic = @{@"content":self.textField.text,@"id":numStr};
                [contentArr addObject:contentDic];
            }
        }else{
            ACArgsUnpack(NSString* numStr) = inArguments;
            self.textField = [_keyDict objectForKey:numStr];
            contentDic = @{@"content":self.textField.text,@"id":numStr};
            [contentArr addObject:contentDic];
        }
        
        
        
        
    }else{
        NSArray *keys = [_keyDict allKeys];
        for (NSString *str in keys) {
            self.textField = [_keyDict objectForKey:str];
            contentDic = @{@"content":self.textField.text,@"id":str};
            [contentArr addObject:contentDic];
            
        }
        
    }
    contentStr = [contentArr ac_JSONFragment];
    //NSString *jsString = [NSString stringWithFormat:@"uexSecurityKeyboard.cbGetContent('%@');",contentStr];
    //[EUtility brwView:meBrwView evaluateScript:jsString];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexSecurityKeyboard.cbGetContent" arguments:ACArgsPack(contentStr)];
    return [contentArr copy];
}
-(NSString*)getData:(NSMutableArray *)inArguments {
    ACArgsUnpack(NSString* numStr) = inArguments;
    if ([_keyDict objectForKey:numStr]) {
        self.textField = [_keyDict objectForKey:numStr];
        return self.textField.text;
    }else{
        return nil;
    }
    
    
}

@end
