//
//  MensajesViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/25/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "MensajesViewController.h"
#import "SBJson.h"
#import "DetailViewController.h"

@interface MensajesViewController (){
    NSArray *table;
    NSArray *of;
    NSArray *text;
    NSArray *date;
    NSArray *code;
}

@end

@implementation MensajesViewController

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    @try {
        
                    NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&password=%@",[defaults objectForKey:@"userVer"],[defaults objectForKey:@"passVer"]];
            
            NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/getM.php"];
            
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
                id object2 = [jsonData valueForKeyPath:@"of"];
                id object3 = [jsonData valueForKeyPath:@"text"];
                id object4 = [jsonData valueForKeyPath:@"date"];
                id object5 = [jsonData valueForKeyPath:@"code"];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    table = [NSArray arrayWithObject:object];
                    of = [NSArray arrayWithObject:object2];
                    text = [NSArray arrayWithObject:object3];
                    date = [NSArray arrayWithObject:object4];
                    code = [NSArray arrayWithObject:object5];
                }
                else{
                    table = object;
                    of = object2;
                    text = object3;
                    date = object4;
                    code = object5;
                }
                NSLog(@"Titulos \n %@", table);
                 NSLog(@"From \n %@", of);
            }
          }
    
    
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Error" :@"Ocurrio un error al Buscar mensajes nuevos"];
    }
    

   
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
    return table.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *title = table[indexPath.row];
    NSString *detail = of[indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"msgDetail" sender:indexPath];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"msgDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *title = table[indexPath.row];
        NSString *ofI = of[indexPath.row];
        NSString *textI = text[indexPath.row];
        NSString *dateI = date[indexPath.row];
        NSString *codeI = code[indexPath.row];
        [[segue destinationViewController] setTitule:title];
        [[segue destinationViewController] setOf:ofI];
        [[segue destinationViewController] setTexto:textI];
        [[segue destinationViewController] setFecha:dateI];
        [[segue destinationViewController] setCode:codeI];
    }
}



@end
