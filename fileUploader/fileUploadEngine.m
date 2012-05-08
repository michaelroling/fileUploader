//
//  fileUploadEngine.m
//  fileUploader
//
//  Created by Michael Roling on 5/7/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "fileUploadEngine.h"

@implementation fileUploadEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:NO];    
    return op;     
}

@end
 