//
//  VistaNuevoRFC.h
//  miOrden
//
//  Created by Rodrigo Higuera on 7/13/11.
//  Copyright 2011 ITAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTableViewModel.h"

@interface VistaNuevoRFC : UITableViewController<SCTableViewModelDelegate> {
    SCTableViewModel *tableModel;
}


@end
