//
//  Chart.m
//  Music4You
//
//  Created by Peter Pike on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "Chart.h"


@implementation Chart

@dynamic chartID;
@dynamic chartName;

// init function of Chart implement
- (id) initWithID:(NSString *) chartID chartName:(NSString *) chartName managedObjectContext:(NSManagedObjectContext *)context {
    Chart *chart = [NSEntityDescription insertNewObjectForEntityForName:@"Chart" inManagedObjectContext:context];
    chart.chartID = chartID;
    chart.chartName = chartName;
    return chart;
}
@end
