//
//  TodayViewController.m
//  TJToday
//
//  Created by 王朋涛 on 16/9/29.
//  Copyright © 2016年 tao. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "ViewController.h"
#import "Masonry.h"
#define RATE_KEY @"tjzlKey"
@interface TodayViewController ()<NCWidgetProviding>
{
    NSArray * images;
    NSArray * tities;
}
@end

@implementation TodayViewController


- (double)usedRate
{
    return [[[NSUserDefaults standardUserDefaults]
             valueForKey:RATE_KEY] doubleValue];
}

- (void)setUsedRate:(double)usedRate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithDouble:usedRate]
                forKey:RATE_KEY];
    [defaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#ifdef __IPHONE_10_0 //因为是iOS10才有的，还请记得适配
    //如果需要折叠
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
#endif
}
static const CGFloat ITEM_SIZE = 50;
static const CGFloat LABEL_HEIGHT = 20;
static const CGFloat LABEL_WIDTH = 100;
static const CGFloat MAX_HEIGHT = 80;

- (void)viewDidLoad {
    [super viewDidLoad];//
    images=@[@"icon_hotel",@"icon_flight",@"icon_train",@"icon_search"];
    tities=@[@"酒店",@"机票",@"火车票",@"搜索"];
    NSString *groupID = @"group.com.tjzl.app";
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:groupID];
    [shared setObject:tities forKey:@"titles"];
    [shared synchronize];
    
    __block UIView *lastSpaceView = [UIView new];
    [self.view addSubview:lastSpaceView];
    [lastSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.height.equalTo(@(MAX_HEIGHT));

    }];
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *itemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setBackgroundImage:[UIImage imageNamed:images[idx]] forState:UIControlStateNormal];
        [self.view addSubview:itemBtn];
        itemBtn.tag=idx;
        [itemBtn addTarget:self action:@selector(openMyApplication:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@(ITEM_SIZE));
            make.left.equalTo(lastSpaceView.mas_right);
            make.top.equalTo(self.view.mas_top).offset(15);//距离父View顶部50点
        }];
        UILabel *label=[UILabel new];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:12];
        label.text=tities[idx];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemBtn.mas_bottom).offset(5);
            make.height.equalTo(@(LABEL_HEIGHT));
            make.width.equalTo(@(LABEL_WIDTH));
            make.centerX.equalTo(itemBtn.mas_centerX);

        }];
        UIView *spaceView = [UIView new];
        [self.view addSubview:spaceView];
        [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemBtn.mas_right).with.priorityHigh(); // 降低优先级，防止宽度不够出现约束冲突
            make.top.and.bottom.equalTo(self.view);
            make.width.equalTo(lastSpaceView.mas_width);
        }];
        lastSpaceView = spaceView;
        
    }];
    
    [lastSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
    }];

}
- (void)openMyApplication:(UIButton *)button
{
    NSString *title=[NSString stringWithFormat:@"%ld",button.tag];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"TJOpenViewController://%@",title]];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    }else{
        self.preferredContentSize = maxSize;
    }
}



@end
