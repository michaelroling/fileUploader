//
//  fileUploadDemoViewController.m
//  fileUploader
//
//  Created by Michael Roling on 5/7/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "fileUploadDemoViewController.h"
#import "ELCImagePickerController.h"
@interface fileUploadDemoViewController ()

@end

@implementation fileUploadDemoViewController{
    ELCImagePickerController *imagePicker;
}

@synthesize flUploadEngine = _flUploadEngine;
@synthesize flOperation = _flOperation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Create the image picker
    imagePicker = [[ELCImagePickerController alloc] initImagePicker];
    imagePicker.maximumImagesCount = 4; //Set the maximum number of images to select, defaults to 4
    imagePicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    imagePicker.imagePickerDelegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)uploadPhoto:(id)sender {
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:	@"Take Photo",
                                        @"Choose from Library",
                                        nil,
                                        nil];
    
    [photoSourcePicker showInView:self.view];   
}

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
		{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
                imagePicker.allowsEditing = NO;
                [self presentModalViewController:imagePicker animated:YES];
            }
            else {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                   message:@"This device doesn't have a camera." 
                                                  delegate:self cancelButtonTitle:@"Ok" 
                                         otherButtonTitles:nil];
                [alert show];                
            }
			break;
		}            
		case 1:
		{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
//                imagePicker.delegate = self;
//                imagePicker.allowsEditing = NO;
//                [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                   message:@"This device doesn't support photo libraries." 
                                                  delegate:self cancelButtonTitle:@"Ok" 
                                         otherButtonTitles:nil];
                [alert show];                
            }            
			break;
		}
	}
}
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [self dismissModalViewControllerAnimated:YES];
    for (NSDictionary*dic in info) {
        [self uploadImageUsingDicInfo:dic];
    }
    

}
-(void)uploadImageUsingDicInfo:(NSDictionary*)dicInfo{
    NSData *image = UIImageJPEGRepresentation([dicInfo objectForKey:UIImagePickerControllerOriginalImage], 0.1);
   
    self.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:@"posttestserver.com" customHeaderFields:nil];
   
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"testApp", @"appID",
                                       nil];
    self.flOperation = [self.flUploadEngine postDataToServer:postParams path:@"/post.php"];
    [self.flOperation addData:image forKey:@"userfl" mimeType:@"image/jpeg" fileName:@"upload.jpg"];
   
    [self.flOperation addCompletionHandler:^(MKNetworkOperation* operation) {
        NSLog(@"%@", [operation responseString]);
        /*
         This is where you handle a successful 200 response
         */
    }
                              errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                  NSLog(@"%@", error);
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:[error localizedDescription]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Dismiss"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }];
    
    [self.flUploadEngine enqueueOperation:self.flOperation ];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    NSData *image = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.1);
    
    self.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:@"posttestserver.com" customHeaderFields:nil];

    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"testApp", @"appID",
                                       nil];      
    self.flOperation = [self.flUploadEngine postDataToServer:postParams path:@"/post.php"];
    [self.flOperation addData:image forKey:@"userfl" mimeType:@"image/jpeg" fileName:@"upload.jpg"];
    
    [self.flOperation addCompletionHandler:^(MKNetworkOperation* operation) {
        NSLog(@"%@", [operation responseString]);
        /*   
            This is where you handle a successful 200 response
        */
    }     
    errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];        
    }];
    
    [self.flUploadEngine enqueueOperation:self.flOperation ];  
    
}
@end
