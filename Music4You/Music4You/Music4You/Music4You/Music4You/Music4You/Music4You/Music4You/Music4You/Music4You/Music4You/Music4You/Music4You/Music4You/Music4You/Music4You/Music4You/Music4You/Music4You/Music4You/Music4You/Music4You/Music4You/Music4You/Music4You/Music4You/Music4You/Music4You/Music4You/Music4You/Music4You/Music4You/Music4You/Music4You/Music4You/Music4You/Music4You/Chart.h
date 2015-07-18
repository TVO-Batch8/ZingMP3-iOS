//
//  Chart.h
//  Music4You
//
//  Created by Peter Pike on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Chart : NSManagedObject

@property (nonatomic, retain) NSString * chartID;
@property (nonatomic, retain) NSString * chartName;

// init function of Chart
- (id) initWithID:(NSString *) chartID chartName:(NSString *) chartName managedObjectContext:(NSManagedObjectContext *)context;
@end
