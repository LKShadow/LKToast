//
//  LKViewController.m
//  LKToast
//
//  Created by 李考 on 08/10/2022.
//  Copyright (c) 2022 李考. All rights reserved.
//

#import "LKViewController.h"
#import <LKToast/LKTips.h>

@interface LKViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *sections;
@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    self.sections = @[@"加载在window上", @"加载在tableView上"];
    self.list = @[@[@"showLoading", @"showWithText", @"showSuccess", @"showError", @"showInfo"],@[@"showLoading"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ls = self.list[section];
    return ls.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.list[indexPath.section][indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    label.text = self.sections[section];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"加载loading");
            [LKTips showLoading];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LKTips hideLoading];
                NSLog(@"隐藏loading");
            });
        }
        if (indexPath.row == 1) {
            [LKTips showWithText:@"showToast2秒后隐藏"];
        }
        if (indexPath.row == 2) {
            [LKTips showSucceed:@"加载成功"];
        }
        if (indexPath.row == 3) {
            [LKTips showError:@"加载失败"];
        }
        if (indexPath.row == 4) {
            [LKTips showInfo:@"加载信息"];
        }
    } else {
        if (indexPath.row == 0) {
            NSLog(@"加载loading");
            [LKTips showLoadingInView:tableView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LKTips hideLoadingInView:tableView];
                NSLog(@"隐藏loading");
            });
        }
    }
    
}


- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight= 45;
        
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableview;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
