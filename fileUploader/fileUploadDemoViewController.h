//
//  fileUploadDemoViewController.h
//  fileUploader
//
//  Created by Michael Roling on 5/7/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileUploadEngine.h"

@interface fileUploadDemoViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) fileUploadEngine *flUploadEngine;
@property (strong, nonatomic) MKNetworkOperation *flOperation;

@end
