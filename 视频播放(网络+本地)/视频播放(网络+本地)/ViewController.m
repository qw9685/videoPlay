//
//  ViewController.m
//  视频播放(网络+本地)
//
//  Created by mac on 2019/11/23.
//  Copyright © 2019 cc. All rights reserved.
//

#import "ViewController.h"
#import "ccTableView.h"
#import "localPlayerViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    ccTableView* tableView = [[ccTableView alloc] initPlainTableView:nil reuseIdentifier:@"cellID" frame:self.view.bounds];
    
    tableView.cc_numberOfRows(^NSInteger(NSInteger section, UITableView * _Nonnull tableView) {
        return 2;
    }).cc_ViewForCell(^(NSIndexPath * _Nonnull indexPath, UITableView * _Nonnull tableView, UITableViewCell * _Nonnull cell) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"本地视频播放";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"网络视频播放";
        }
        
    }).cc_didSelectRowAtIndexPath(^(NSIndexPath * _Nonnull indexPath, UITableView * _Nonnull tableView) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[localPlayerViewController new] animated:YES];
        }
    });
    
    [self.view addSubview:tableView];
}


@end
