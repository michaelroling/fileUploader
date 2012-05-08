//
//  fileUploadEngine.h
//  fileUploader
//
//  Created by Michael Roling on 5/7/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface fileUploadEngine : MKNetworkEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path;

@end
