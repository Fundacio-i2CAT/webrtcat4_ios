/*
 *  Copyright 2014 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCSessionDescription+JSON.h"

static NSString const *kRTCSessionDescriptionTypeKey = @"type";
static NSString const *kRTCSessionDescriptionSdpKey = @"sdp";

@implementation RTCSessionDescription (JSON)

+ (RTCSessionDescription *)descriptionFromJSONDictionary:
    (NSDictionary *)dictionary {
  NSString *typeString = dictionary[kRTCSessionDescriptionTypeKey];
  RTCSdpType type = [[self class] typeForString:typeString];
  NSString *sdp = dictionary[kRTCSessionDescriptionSdpKey];
    NSLog(@"mirem %@", dictionary);

    
    NSArray *arr = [sdp componentsSeparatedByString:@"\n"];
    NSLog(@"mirem count %i", arr.count);

    NSMutableArray* newArray = [NSMutableArray new];
    for (NSString* comp in arr){
        NSString* newComp = comp;
        if([comp containsString:@"ufrag"]){
            newComp = [comp stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            
        }
        if([comp containsString:@"ice-pwd"]){
            newComp = [comp stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        }
        [newArray addObject:newComp];
    }
    
    
  return [[RTCSessionDescription alloc] initWithType:type sdp:[newArray componentsJoinedByString:@"\n"]];
}

- (NSData *)JSONData {
  NSString *type = [[self class] stringForType:self.type];
  NSDictionary *json = @{
    kRTCSessionDescriptionTypeKey : type,
    kRTCSessionDescriptionSdpKey : self.sdp
  };
  return [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
}

@end
