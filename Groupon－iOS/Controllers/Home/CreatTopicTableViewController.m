//
//  CreatTopicTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "CreatTopicTableViewController.h"
#import "UIView+Toast.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
@interface CreatTopicTableViewController ()<UIAlertViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageView;

@property (nonatomic, assign)BOOL couldSend;

@end
@implementation CreatTopicTableViewController
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [User shareUser].topicData = nil;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(end)];
    [self.tableView addGestureRecognizer:gesture];
}
- (void)end{
    [self.tableView endEditing:YES];
}
- (IBAction)sendTopic:(id)sender {
    
    if (_couldSend) {
        return;
    }
    _couldSend = YES;
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"发布公告中...";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:3];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (!self.titleLabel.text.length > 0) {
        [self showToastWithMessage:@"标题不能为空，请输入标题"];

        return;
    }
    
    if (!self.contentView.text.length > 0) {
        [self showToastWithMessage:@"内容不能为空，请输入标题"];
        return;
    }
    if ([NSString stringContainsEmoji:self.titleLabel.text]) {
        [self showToastWithMessage:@"标题不能包含表情，请删除表情后再发布"];
        return;
    }
    
    if ([NSString stringContainsEmoji:self.contentView.text]) {
         [self showToastWithMessage:@"内容不能包含表情，请删除表情后再发布"];
        return;
    }
    
    [dict setObject:[User shareUser].userID forKey:@"user_id"];
    [dict setObject:self.titleLabel.text forKey:@"title"];
    [dict setObject:self.contentView.text forKey:@"body"];
    [dict setObject:@"默认" forKey:@"category"];
    
    [[GoldenLeafNetworkAPIManager shareManager] request_createTopicWithParams:dict withData:nil andBlock:^(id data, NSError *error) {
        
        if (error) {
            [hud hide:YES];
            _couldSend = NO;
            [self showToastWithMessage:@"服务器繁忙，请稍候再试"];
        }else{
//            DebugLog(@"%@", data);
            [User shareUser].topicData = nil;
            [hud hide:YES];
            _couldSend = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }];

}
- (IBAction)changeImage:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择更换头像的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [sheet showInView:self.view];
}
#pragma mark -
#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            self.newMedia = YES;
        }
    } else if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            self.newMedia = NO;
        }
    }
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
//        NSData *data = UIImagePNGRepresentation(image);
        NSData *data = UIImageJPEGRepresentation(image, 0.2);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:data forKey:@"PROFILE_IMAGE"];
        [prefs synchronize];
        [User shareUser].topicData = data;
        [self.imageView setImage:image forState:UIControlStateNormal];
        if (_newMedia) {
            UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:finishedSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tableView endEditing:YES];
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}
@end
