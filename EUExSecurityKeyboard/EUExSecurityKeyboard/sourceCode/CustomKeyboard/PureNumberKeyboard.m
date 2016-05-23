//
//  PureNumberKeyboard.m
//  EUExCustomKeyboard
//
//  Created by 杨广 on 16/2/18.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "PureNumberKeyboard.h"
#import "EUtility.h"
#import <Masonry/Masonry.h>
@implementation PureNumberKeyboard
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
                make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(0);
            }else{
                make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(0);
            }
            if (lastView) {
                make.height.mas_equalTo(lastView);
            }
        }];
        lastView = view;
        view.tag = 1000+i;
    }
    NSArray *titles1 = @[@"1",@"2",@"3"];
    [self setCharKeyboard:1000 count:3 distance:0 titles:titles1 buttonTag:1];
    NSArray *titles2 = @[@"4",@"5",@"6"];
    [self setCharKeyboard:1001 count:3 distance:0 titles:titles2 buttonTag:4];
    NSArray *titles3 = @[@"7",@"8",@"9"];
    [self setCharKeyboard:1002 count:3 distance:0 titles:titles3 buttonTag:7];
    NSArray *titles4 = @[@"完成",@"0",@""];
    [self setCharKeyboard:1003 count:3 distance:0 titles:titles4 buttonTag:10];
}
-(void)setCharKeyboard:(NSInteger)viewTag count:(NSInteger)count distance:(NSInteger)distance titles:(NSArray *)titles buttonTag:(NSInteger)buttonTag{
    UIView *view1 = (UIView*)[self viewWithTag:viewTag];
    UIView *lastView1 = nil;
    for (int i = 0; i < count; i ++) {
        UIButton *btn=[UIButton buttonWithType:0];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:[EUtility screenWidth] /15];
        
        [view1 addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            if (i == 0) {
                make.left.mas_equalTo(distance);
            }else if(i == count - 1){
                make.right.mas_equalTo(-distance);
                make.left.mas_equalTo(lastView1.mas_right).mas_equalTo(0);
            }else{
                make.left.mas_equalTo(lastView1.mas_right).mas_equalTo(0);
            }
            if (lastView1) {
                make.width.mas_equalTo(lastView1);
            }
        }];
        lastView1 = btn;
        btn.tag = buttonTag+i;
        if ( btn.tag == 10) {
            [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_1_last_row.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_1_last_row_pressed.png"] forState:UIControlStateHighlighted];
        }else if(btn.tag == 12){
            [btn setImage:[self imagesNamedFromCustomBundle:@"key_backspace_pressed.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_3_last_row.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_3_last_row_pressed.png"] forState:UIControlStateHighlighted];
            
        }else if(btn.tag == 11){
            [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_2_last_row.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_2_last_row_pressed.png"] forState:UIControlStateHighlighted];
            
        }else {
            if (btn.tag == 1 || btn.tag == 4 || btn.tag == 7) {
                [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_1.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_1_pressed.png"] forState:UIControlStateHighlighted];
            }else if(btn.tag == 3 || btn.tag == 6 || btn.tag == 9){
                [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_3.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_3_pressed.png"] forState:UIControlStateHighlighted];
            }else {
                [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_2.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[self imagesNamedFromCustomBundle:@"key_num_column_2_pressed.png"] forState:UIControlStateHighlighted];
            }
        }
        
        [btn addTarget:self action:@selector(numbleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
}

- (void)numbleButtonClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSInteger number = btn.tag;
    if (nil == _delegate)
    {
        NSLog(@"button tag [%ld]",(long)number);
        return;
    }
    
    if ((number <= 9 && number >= 1) || number == 11)
    {
        NSString*str = btn.currentTitle;
        [_delegate numberKeyBoardInput:str];
        return;
    }
    
    if (10 == number)
    {
        
       [_delegate numberKeyBoardFinish];
        return;
    }
    
    if (12 == number)
    {
        [_delegate numberKeyBoardDelete];
        return;
    }
    
    
}
@end

