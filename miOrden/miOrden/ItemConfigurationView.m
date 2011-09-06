//
//  ItemConfigurationView.m
//  miOrden
//
//  Created by Sebastian Barrios on 9/4/11.
//  Copyright 2011 ITAM. All rights reserved.
//

#import "ItemConfigurationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ItemConfigurationView
@synthesize itemId;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    tableModel = [[SCTableViewModel alloc] initWithTableView:self.tableView withViewController:self];
    
    XMLThreadedParser *parser = [[XMLThreadedParser alloc] init];
    parser.delegate = self;
    NSString *urlString = [NSString stringWithFormat:@"http://www.miorden.com/demo/iphone/dish_addon.php?itemid=%@",itemId];
    [parser parseXMLat:[NSURL URLWithString:urlString] withKey:@"dish-addon"];
}

- (void)tableViewModel:(SCTableViewModel *)tableViewModel didLayoutSubviewsForCell:(SCTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell.textLabel.text isEqualToString:@"Peticiones\nEspeciales"]) {
        //cell.textLabel.layer.borderWidth = 1.0;
        cell.textLabel.numberOfLines = 2;
    }
}

- (void)parser:(XMLThreadedParser *)parser didParseObject:(NSDictionary *)object{
    
}

- (void)parser:(XMLThreadedParser *)parser didFinishParsing:(NSArray *)array{
    SCTableViewSection *section = [[SCTableViewSection alloc] initWithHeaderTitle:@"Configura tu Pedido"];
    
    SCNumericTextFieldCell *quantityCell = [SCNumericTextFieldCell cellWithText:@"Cantidad" withBoundKey:@"quantityKey" withValue:[NSNumber numberWithInt:1]];
    quantityCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    [section addCell:quantityCell];
    
    //Get Extra things
    for (NSDictionary *extra in array) {
        SCTableViewCell *cell;
        
        cell = [SCSelectionCell cellWithText:[extra valueForKey:@"title"] withBoundKey:nil withSelectedIndexValue:nil withItems:nil];
        /*
        if ([[extra valueForKey:@"multiple"] isEqualToString:@"1"]) {
            cell = [SCSelectionCell cellWithText:[extra valueForKey:@"title"] withBoundKey:nil withSelectedIndexValue:nil withItems:nil];
        }
        else{
            
        }
        */
        [section addCell:cell];
    }
    
    SCTextFieldCell *nameCell = [SCTextFieldCell cellWithText:@"Para" withPlaceholder:@"Nombre Comenzal" withBoundKey:@"recipientnameKey" withTextFieldTextValue:nil];
    [section addCell:nameCell];
    
    SCTextViewCell *peticionesEspeciales = [SCTextViewCell cellWithText:@"Peticiones\nEspeciales" withBoundKey:@"specialRequestKey" withValue:nil];
    [section addCell:peticionesEspeciales];
    
    [tableModel addSection:section];
    
    [self.tableView reloadData];
}


@end
