//
//  ViewController.m
//  TJWidget
//
//  Created by 王朋涛 on 16/9/29.
//  Copyright © 2016年 tao. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()
{
    UILabel *label;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    label=[[UILabel alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:label];
    label.textAlignment=NSTextAlignmentCenter;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(mytest:) name:@"ExtenicationNotification" object:nil];
    label.text=@"点击widget页面";

}
- (void) mytest:(NSNotification*) notification
{
    id obj = [notification object];//获取到传递的对象
    NSString *groupID = @"group.com.tjzl.app";
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:groupID];
    NSArray *array = [shared objectForKey:@"titles"];
    NSString * idx =obj;
    label.text=[NSString stringWithFormat:@"跳转%@的页面",array[idx.intValue]];

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSArray *keys = @[@"AC",@"+/-",@"%",@"÷"
                      ,@"7",@"8",@"9",@"x"
                      ,@"4",@"5",@"6",@"-"
                      ,@"1",@"2",@"3",@"+"
                      ,@"0",@"?",@".",@"="];
    int indexOfKeys = 0;
    for (NSString *key in keys){
        //循环所有键
        indexOfKeys++;
        int rowNum = indexOfKeys %4 ==0? indexOfKeys/4:indexOfKeys/4 +1;
        int colNum = indexOfKeys %4 ==0? 4 :indexOfKeys %4;
        NSLog(@"key :%@ row : %d col : %d",key,rowNum,colNum);

    }
    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
