//
//  ViewController.m
//  DLAnimation
//
//  Created by DEMO on 16/3/7.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import "ViewController.h"
#import "DLAnimationView.h"

@interface ViewController ()
{
    DLAnimationView *  _animationView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _animationView = ({
        DLAnimationView * view = [[DLAnimationView alloc] initWithFrame:self.view.bounds];
        
        view;
    });
    
    
    UIButton * btnPlay = ({
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [btn setTitle:@"play" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(playAnimation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    
    
    __weak typeof (DLAnimationView *) weakAni = _animationView;
    _animationView.completionBlock = ^(){
        [weakAni removeFromSuperview];
    };
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playAnimation {
    [self.view addSubview:_animationView];
    [_animationView setUpOrigin];
}

@end
