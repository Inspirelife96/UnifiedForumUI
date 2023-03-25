//
//  UFUIMeViewController.m
//  Bolts
//
//  Created by XueFeng Chen on 2021/10/29.
//

#import "UFUIMeViewController.h"

#import "UFUISettingViewController.h"

@interface UFUIMeViewController ()

@property (nonatomic, strong) UIBarButtonItem *settingBarButtonItem;

@end

@implementation UFUIMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.settingBarButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)clickSettingButton:(id)sender {
    UFUISettingViewController *settingVC = [[UFUISettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (UIBarButtonItem *)settingBarButtonItem {
    if (!_settingBarButtonItem) {
        _settingBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSettingButton:)];
        _settingBarButtonItem.tintColor = [UIColor systemRedColor];
    }
    
    return _settingBarButtonItem;
}

@end
