//
//  CalculatorViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-07.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UITextField *salaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *daysTextField;

@property (strong, nonatomic) UIPickerView *salaryPicker;
@property (strong, nonatomic) UIPickerView *daysPicker;

- (IBAction)calculate:(id)sender;

@end
