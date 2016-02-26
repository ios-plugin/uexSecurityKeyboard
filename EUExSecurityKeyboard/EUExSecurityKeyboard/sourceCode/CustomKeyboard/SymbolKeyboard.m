//
//  SymbolKeyboard.m
//  EUExCustomKeyboard
//
//  Created by 杨广 on 16/2/18.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "SymbolKeyboard.h"
#import "EUtility.h"
#import "Masonry.h"
@implementation SymbolKeyboard
- (id)initWithFrame:(CGRect)frame keyboardDescription:(NSString*)keyboardDescription
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage * image  = [self imagesNamedFromCustomBundle:@"kb_bg1.png"];
        
        self.image = image;
        self.userInteractionEnabled = YES;
        self.keyboardDescription = keyboardDescription;
        [self customView:frame];
    }
    return self;
}
- (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName
{
    
    NSBundle *bundle = [EUtility bundleForPlugin:@"uexCustomKeyboard"];
    NSString *img_path = [[bundle resourcePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imgName]];
    return [UIImage imageWithContentsOfFile:img_path];
}
- (void)customView:(CGRect)frame{
    CGFloat kTopLabelHeight = frame.size.height /6;
    //-------------------
    UIView *view = [UIView new];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kTopLabelHeight);
    }];
    //------------------------------
    UILabel *label = [UILabel new];
    label.text = self.keyboardDescription;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完 成" forState:UIControlStateNormal];
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter ;
    button.tag = 130;
    [button setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_2_last_row_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(numbleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(70);
    }];
    UIImageView *imageView = [UIImageView new];
    imageView.image =[self imagesNamedFromCustomBundle:@"kb_bg_line.png"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(view.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *lastView = nil;
    for (int i = 0; i < 4; i ++) {
        UIView *view=[UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            if (i == 0) {
                make.top.mas_equalTo(kTopLabelHeight +1);
            }else if(i == 3){
                make.bottom.mas_equalTo(0);
                make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(1);
            }else{
                make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(1);
            }
            if (lastView) {
                make.height.mas_equalTo(lastView);
            }
        }];
        lastView = view;
        view.tag = 1000+i;
    }
    //    //-------------------------------------------
    NSArray *titles1 = @[@"!",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")"];
    NSArray *titles2 =@[@"'",@"\"",@"=",@"_",@":",@";",@"?",@"~",@"|",@"•"];
    [self setCharKeyboard:1000 count:10 distanceLeft:5 distanceRight:5  titles:titles1 buttonTag:300];
    [self setCharKeyboard:1001 count:10 distanceLeft:5 distanceRight:5  titles:titles2 buttonTag:311];
    
    //----------------------------------------------------
    UIView *view2 = (UIView*)[self viewWithTag:1002];
    UIButton *btn1=[UIButton buttonWithType:0];
    [btn1 setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_fat_bg_blue.png"] forState:UIControlStateNormal];
    [btn1 setImage:[self imagesNamedFromCustomBundle:@"key_backspace_normal.png"] forState:UIControlStateNormal];
    [btn1 setImage:[self imagesNamedFromCustomBundle:@"key_icon_del.png"] forState:UIControlStateHighlighted];
    btn1.tag = 337;
    [btn1 addTarget:self action:@selector(numbleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(50);
    }];
    NSArray *titles3 = @[@"+",@"-",@"\\",@"/",@"[",@"]",@"{",@"}"];
    [self setCharKeyboard:1002 count:8 distanceLeft:15 distanceRight:70 titles:titles3 buttonTag:321];
    //------------------------------------------------------
    UIView *view3 = (UIView*)[self viewWithTag:1003];
    UIButton *btn3=[UIButton buttonWithType:0];
    btn3.tag = 338;
    [btn3 setTitle:@"123" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn3 setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_mood_normal.png"] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_mood_pressed.png"] forState:UIControlStateHighlighted];
    [btn3 addTarget:self action:@selector(numbleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(50);
    }];

    UIButton *btn5=[UIButton buttonWithType:0];
    btn5.tag = 339;
    [btn5 setTitle:@"ABC" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn5 setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_mood_normal.png"] forState:UIControlStateNormal];
    [btn5 setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_mood_pressed.png"] forState:UIControlStateHighlighted];
    [btn5 addTarget:self action:@selector(numbleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:btn5];
    [btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(50);
    }];
     NSArray *titles4 = @[@",",@".",@"<",@">",@"€",@"£",@"¥"];
    [self setCharKeyboard:1003 count:7 distanceLeft:65 distanceRight:65 titles:titles4 buttonTag:329];
}
-(void)setCharKeyboard:(NSInteger)viewTag count:(NSInteger)count distanceLeft:(NSInteger)distanceLeft distanceRight:(NSInteger)distanceRight  titles:(NSArray *)titles buttonTag:(NSInteger)buttonTag{
    UIView *view1 = (UIView*)[self viewWithTag:viewTag];
    UIView *lastView1 = nil;
    for (int i = 0; i < count; i ++) {
        UIButton *btn=[UIButton buttonWithType:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:[EUtility screenWidth] /17];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_fat_normal.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_fat_bg_blue.png"] forState:UIControlStateHighlighted];
        [view1 addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            if (i == 0) {
                make.left.mas_equalTo(distanceLeft);
            }else if(i == count - 1){
                make.right.mas_equalTo(-distanceRight);
                make.left.mas_equalTo(lastView1.mas_right).mas_equalTo(5);
            }else{
                make.left.mas_equalTo(lastView1.mas_right).mas_equalTo(5);
            }
            if (lastView1) {
                make.width.mas_equalTo(lastView1);
            }
        }];
        lastView1 = btn;
        btn.tag = buttonTag+i;
        [btn addTarget:self action:@selector(numbleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (void)numbleButtonClicked:(id)sender{
    UIButton* btn = (UIButton*)sender;
    NSInteger number = btn.tag;
    if (nil == _delegate)
    {
        NSLog(@"button tag [%ld]",(long)number);
        return;
    }
    if (number <= 336 && number >= 300)
    {
        NSString *str = btn.currentTitle;
        [_delegate numberKeyBoardInput:str];
        return;
    }
    if (number == 338) {
        
        [_delegate numberKeyBoardChange:number];
        return;
    }
    if (number == 339) {
        [_delegate numberKeyBoardChange:number];
        return;
    }
    if (number == 337)
    {
        [_delegate numberKeyBoardDelete];
        return;
    }
    
    
    if (number == 130)
    {
        [_delegate numberKeyBoardFinish];
        return;
    }
}
@end

