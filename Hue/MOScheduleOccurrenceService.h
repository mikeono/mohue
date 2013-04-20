//
//  MOHueScheduleOccurrenceService.h
//  Hue
//
//  Created by Mike Onorato on 4/15/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModelService.h"

@class MOScheduleOccurrenceList;

@interface MOScheduleOccurrenceService : MOModelService

+ (void)getOccurrenceListWithCompletion:(void(^)(MOScheduleOccurrenceList*, NSError*))completion;

+ (void)deleteAllOccurrencesOfUUID:(NSString*)scheduleUUID withCompletion:(void(^)(BOOL success))completion;

+ (void)deleteOccurrenceWithHueIdString:(NSString*)hueIdString withCompletion:(void(^)(BOOL success))completion;

@end
