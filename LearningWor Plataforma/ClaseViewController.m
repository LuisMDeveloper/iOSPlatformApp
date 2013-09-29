//
//  ClaseViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/28/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "ClaseViewController.h"
#import "SBJson.h"
#import "ClaseDetailViewController.h"

@interface ClaseViewController (){
    NSUserDefaults *defaults;
    NSArray *topic;
    NSArray *cUrlD;
    NSArray *texto;
}

@end

@implementation ClaseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        
        NSString *post =[[NSString alloc] initWithFormat:@"curseCode=%@",[defaults objectForKey:@"curseCode"]];
        NSLog(@"%@", post);
        NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/getC.php"];
        
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
            id object = [jsonData valueForKeyPath:@"topic"];
            id object2 = [jsonData valueForKeyPath:@"url"];
            id object3 = [jsonData valueForKeyPath:@"text"];
            if ([object isKindOfClass:[NSDictionary class]]) {
                topic  = [NSArray arrayWithObject:object];
                cUrlD = [NSArray arrayWithObject:object2];
                texto = [NSArray arrayWithObject:object3];
            }
            else{
                topic  = object;
                cUrlD = object2;
                texto = object3;
            }
            
            
        }
        else{
            
        }
    }
    
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
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
    return topic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     NSString *title = topic[indexPath.row];
    cell.textLabel.text = title;
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"clasesSeg" sender:indexPath];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"clasesSeg"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *tituloC = topic[indexPath.row];
        NSString *urlC = cUrlD[indexPath.row];
        NSString *textoC = texto[indexPath.row];
        
        [[segue destinationViewController] setTopic:tituloC];
        [[segue destinationViewController] setCurlD:urlC];
        [[segue destinationViewController] setTexto:textoC];
        
    }

}



@end
