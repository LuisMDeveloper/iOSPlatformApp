//
//  DetailViewController.h
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/26/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) id titule;
@property (strong, nonatomic) id of;
@property (strong, nonatomic) id texto;
@property (strong, nonatomic) id fecha;
@property (strong, nonatomic) id code;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *ofL;
@property (weak, nonatomic) IBOutlet UITextView *textL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;


@end
