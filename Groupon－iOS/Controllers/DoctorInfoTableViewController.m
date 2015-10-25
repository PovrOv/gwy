//
//  DoctorInfoTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/26.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "DoctorInfoTableViewController.h"
#import "DoctorInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface DoctorInfoTableViewController ()


@property (nonatomic, strong)NSMutableArray *doctorUser;

@end

@implementation DoctorInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 100;
    self.title = @"作者介绍";
    self.doctorUser = [[NSMutableArray alloc] init];
    [self getUserList];
}
- (void)getUserList{
    [[GoldenLeafNetworkAPIManager shareManager] request_getUserListWithPath:@"/api/v1/users-public" andBlock:^(id data, NSError *error) {
        if (error) {
            return ;
        }
        [self.doctorUser removeAllObjects];
        for (NSDictionary *dict in data[@"data"]) {
            [self.doctorUser addObject:dict];
        }
        
        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.doctorUser.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.doctorUser[indexPath.row];
    DoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    cell.nameLabel.text = dict[@"user_name"];
    
    NSString *hospital = (dict[@"hospital"] && ([dict[@"hospital"] respondsToSelector:@selector(isEqualToString:)]))? dict[@"hospital"] : @"";
    cell.hospitalNameLabel.text = [NSString stringWithFormat:@"%@",hospital];
    
    NSString *occupation = (dict[@"occupation"] && ([dict[@"occupation"] respondsToSelector:@selector(isEqualToString:)]))? dict[@"occupation"] : @"";
    cell.professionalLabel.text = [NSString stringWithFormat:@"%@", occupation];
    NSString *url = [NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"picture"]];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"common_icon_male"]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
