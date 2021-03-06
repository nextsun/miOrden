//
//  VistaInicioSesion.m
//  miOrden
//
//  Created by Rodrigo Higuera on 7/13/11.
//  Copyright 2011 ITAM. All rights reserved.
//

#import "VistaInicioSesion.h"
#import "VistaRegistro.h"
#import "VistaCuentaPerfil.h"
#import "NSString+MD5.h"

@implementation VistaInicioSesion
@synthesize ID, recordar    ;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [tableModel  release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arregloUserId = [[NSMutableArray alloc] init];
    tableModel = [[SCTableViewModel alloc] initWithTableView:self.tableView withViewController:self];
    SCTableViewSection *section1 = [SCTableViewSection sectionWithHeaderTitle:@"Inicio de Sesión"];
    SCTextFieldCell *email = [SCTextFieldCell cellWithText:@"Email" withPlaceholder:@"ingresa tu Email" withBoundKey:@"emailKey" withTextFieldTextValue:nil];
    email.textField.keyboardType = UIKeyboardTypeEmailAddress;
    SCTextFieldCell *pass = [SCTextFieldCell cellWithText:@"Contraseña" withPlaceholder:@"ingresa tu Contraseña" withBoundKey:@"passwordKey" withTextFieldTextValue:nil];
    pass.textField.secureTextEntry = YES;
    [tableModel addSection:section1];
    [section1 addCell:email];
    [section1 addCell:pass];
    
    
    recordar = [[SCSwitchCell alloc]initWithText:@"Recordarme?"];
    recordar.selectionStyle = UITableViewCellSelectionStyleNone;

    [section1 addCell:recordar];
    
    SCTableViewSection *section3 = [SCTableViewSection section];
    SCTableViewCell *iniciar = [[SCTableViewCell alloc]initWithText:@"Iniciar Sesión"];
    iniciar.textLabel.textColor = [UIColor whiteColor];
    //iniciar.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImage *imagenInicio = [UIImage imageNamed:@"boton_iniciar_sesion.png"];
    
    UIImageView *inicioConImagen = [[UIImageView alloc]initWithImage:imagenInicio];
    [inicioConImagen setFrame:CGRectMake(0, 0, 300, 45)];
    inicioConImagen.contentMode = UIViewContentModeScaleToFill;
    [iniciar.contentView insertSubview:inicioConImagen atIndex:0];
    //[iniciar.contentView addSubview:inicioConImagen];
    
    
    
    
    section3.footerTitle = @"¿Olvidaste tu Contraseña? \n ¡Presiona Aquí!";
    
    [inicioConImagen release];
    
    [section3 addCell:iniciar];
    
    SCTableViewSection *section4 = [SCTableViewSection section];
    SCTableViewCell *registro = [[SCTableViewCell alloc]initWithText:@"¡Registrarme!"];
    registro.textLabel.textColor = [UIColor whiteColor];
    UIImage *imagenregistro = [UIImage imageNamed:@"boton_registrate.png"];
    UIImageView *registroConImagen = [[UIImageView alloc]initWithImage:imagenregistro];
    [registroConImagen setFrame:CGRectMake(0, 0, 300, 45)];
    registroConImagen.contentMode = UIViewContentModeScaleAspectFit;
    //[registro.contentView addSubview:registroConImagen];
    [registro.contentView insertSubview:registroConImagen atIndex:0];
    [registroConImagen release];
    
    //registro.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [section4 addCell:registro];
    
    
    [tableModel addSection:section3];
    [tableModel addSection:section4];
    
   
    UIImageView *titleImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titulo.png"]];
    self.navigationItem.titleView = titleImageview;
    [titleImageview release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableViewModel:(SCTableViewModel *)tableViewModel didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        
        
        
        
        VistaRegistro *registro = [[VistaRegistro alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:registro animated:YES];
        [registro release];
        
    }else if(indexPath.section == 1){
        
        XMLThreadedParser *parser = [[XMLThreadedParser alloc] init];
        parser.delegate = self;
        NSString *username = [tableViewModel.modelKeyValues valueForKey:@"emailKey"];
        NSString *pass = [tableViewModel.modelKeyValues valueForKey:@"passwordKey"];
        pass = [pass md5];
        NSString *cadena = [NSString stringWithFormat:@"http://www.miorden.com/demo/iphone/login.php?username=%@&password=%@",username,pass];
        
        [parser parseXMLat:[NSURL URLWithString:cadena]withKey:@"user_id"];
        
        
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
      *detailViewController = [ alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(void)parser:(XMLThreadedParser*)parser didParseObject:(NSDictionary*)object{
    
}



-(void)parser:(XMLThreadedParser*)parser didFinishParsing:(NSArray*)array{
    arregloUserId = [array mutableCopy];
    UIAlertView *alerta;
    ID = [[arregloUserId objectAtIndex:0]valueForKey:@"text"];
    if([ID isEqualToString:@"0"]){
        alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Nombre de usuario o contraseña inválidos" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alerta show];
        [alerta release];
    }else if([ID isEqualToString:@"-1"]){
        alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Introduzca un usuario y contraseña" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alerta show];
        [alerta release];
    }else{
        if(recordar.switchControl.on){
            NSUserDefaults *loginDefault = [NSUserDefaults standardUserDefaults];
            [loginDefault setValue:[tableModel.modelKeyValues valueForKey:@"emailKey"] forKey:@"userKey"];
            [loginDefault setValue:[tableModel.modelKeyValues valueForKey:@"passwordKey"] forKey:@"passKey"];
            [loginDefault setValue:ID forKey:@"userIdKey"];
            [loginDefault synchronize];
        }
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

@end
