//
//  CalculatorViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-07.
//  Copyright (c) 2012 . All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController () {
    double salary;
}

@property (strong, nonatomic) NSArray *salaries;
@property (strong, nonatomic) NSNumberFormatter *currencyStyle;

@end

@implementation CalculatorViewController
@synthesize costTextField;
@synthesize salaryTextField;
@synthesize daysTextField;
@synthesize salaryPicker;
@synthesize daysPicker;
@synthesize salaries;
@synthesize currencyStyle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *amounts = [NSMutableArray arrayWithCapacity:20];
        for (int salary=20000; salary<220000; salary+=10000) {
            [amounts addObject:[NSNumber numberWithInt:salary]];
        }
        self.salaries = [amounts copy];
    }
    return self;
}

- (void)awakeFromNib {
    self.currencyStyle = [[NSNumberFormatter alloc] init];
    [self.currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [self.currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    [self.currencyStyle setLocale:[NSLocale currentLocale]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.salaryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.salaryPicker.delegate = self;
    self.salaryPicker.dataSource = self;
    
    self.daysPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.daysPicker.delegate = self;
}

- (void)viewDidUnload
{
    [self setCostTextField:nil];
    [self setSalaryTextField:nil];
    [self setDaysTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)calculate:(id)sender {
    NSInteger days = self.daysTextField.text.integerValue;
    
    double weekly = salary / 52.0f / 5.0f;
    double cost = weekly * (double)days;
    
    self.costTextField.text = [currencyStyle stringFromNumber:[NSNumber numberWithDouble:cost]];
    
    [self.salaryTextField resignFirstResponder];
    [self.daysTextField resignFirstResponder];
}

#pragma mark - text field delegates
 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.costTextField) {
        return NO;
    }
    self.costTextField.text = nil;
//    else {
//        textField.text = nil;
//    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"did end editing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.salaryTextField) {
        salary = textField.text.doubleValue;
        NSNumber *salaryNumber = [NSNumber numberWithInteger:salary];
        NSString *formatted = [self.currencyStyle stringFromNumber:salaryNumber];
        textField.text = formatted;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.daysTextField) {
        [self calculate:nil];
        return YES;
    }
    [self.daysTextField becomeFirstResponder];
    return NO;
}

#pragma mark - UIPickerView delegate/datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.salaryPicker) {
        return self.salaries.count;
    }
    return 360;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.salaryPicker) {
        return [self.salaries objectAtIndex:row];
    }
    return @"";
}

@end
