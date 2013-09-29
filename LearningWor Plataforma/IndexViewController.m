//
//  IndexViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/25/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "IndexViewController.h"
#import "SBJson.h"

@interface IndexViewController (){
    NSArray *msgcount;
    NSString *msgnum;
    NSUserDefaults *defaults;
}

@end

@implementation IndexViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *welcomeString = [NSString stringWithFormat:@"Bienvenido: %@", [defaults objectForKey:@"userVer"]];
    self.title = welcomeString;
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        
        NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&password=%@",[defaults objectForKey:@"userVer"],[defaults objectForKey:@"passVer"]];
        
        NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/getCU.php"];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %d", [response statusCode]);
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            
            
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
            
            NSLog(@"%@",jsonData);
            NSArray * userC;
            id object = [jsonData valueForKeyPath:@"code_u"];
            if ([object isKindOfClass:[NSDictionary class]]) {
             userC  = [NSArray arrayWithObject:object];
            }
            else{
               userC  = object;
            }
            NSString *string = [userC objectAtIndex:0];
            [defaults setObject:string forKey:@"userCode"];
            
        }
        else{
            
        }
    }
    
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
            }

    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        
        NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&password=%@",[defaults objectForKey:@"userVer"],[defaults objectForKey:@"passVer"]];
        
        NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/countM.php"];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %d", [response statusCode]);
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            
            
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
            
            NSLog(@"%@",jsonData);
            id object = [jsonData valueForKeyPath:@"issue"];
            if ([object isKindOfClass:[NSDictionary class]]) {
                msgcount = [NSArray arrayWithObject:object];
            }
            else{
                msgcount = object;
            }
            msgnum = [NSString stringWithFormat:@"Nuevos: %d", msgcount.count];
            
        }
        else{
            
        }
    }
    
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Error" :@"Ocurrio un error al Buscar mensajes nuevos"];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Mensajes";
            cell.detailTextLabel.text = msgnum;
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = @"Tareas";
            cell.detailTextLabel.text = @"";
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = @"Clases";
            cell.detailTextLabel.text = @"";
        }
        else if (indexPath.row == 3){
            cell.textLabel.text = @"Cerrar Sesion";
            cell.detailTextLabel.text = @"";
        }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"msg" sender:self];
        }
        else if (indexPath.row == 1){
            defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"T" forKey:@"cursoSeg"];
            [self performSegueWithIdentifier:@"cursoSegue" sender:self];
        }
        else if (indexPath.row == 2){
            [defaults setObject:@"C" forKey:@"cursoSeg"];
            [self performSegueWithIdentifier:@"cursoSegue" sender:self];
        }
        else if (indexPath.row == 3){
            defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"null" forKey:@"user"];
            [defaults setObject:@"null" forKey:@"pass"];
            [defaults setObject:nil forKey:@"userVer"];
            [defaults setObject:nil forKey:@"passVer"];
            [self performSegueWithIdentifier:@"closeSeg" sender:self];
        }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}



@end
