//
//  DEAlarmViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 11.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEAlarmViewController.h"
#import <SIAlertView/SIAlertView.h>
#import <EventKit/EventKit.h>

#define COMPONENTRECT CGRectMake(45, 185, DK_SLIDER_SIZE-90, DK_SLIDER_SIZE-90)


@interface DEAlarmViewController ()

@end

@implementation DEAlarmViewController
@synthesize guidedCSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sliderTextValues = [NSMutableArray new];
    self.sliderTextValues = @[@"Ohne",@"Zum Startzeitpunkt",@"5min vorher", @"15min vorher",@"30min vorher", @"1h vorher",@"2h vorher",@"1 Tag vorher",@"2 Tage vorher",@"1 Woche vorher"];
    
    guidedCSlider = [[DKCircularSlider alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-(DK_SLIDER_SIZE-90)/2, self.view.frame.size.height/2-(DK_SLIDER_SIZE-90)/2+32, DK_SLIDER_SIZE-90, DK_SLIDER_SIZE-90)
                                               withElements:self.sliderTextValues
                                           withContentImage:nil
                                                  withTitle:@""
                                                 withTarget:self usingSelector:@selector(sliderChange:)];
    [[self view] addSubview:guidedCSlider];
    [guidedCSlider movehandleToValue:1];
    self.navigationItem.title = @"Erinnerung";
    
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hinzufügen" style:UIBarButtonItemStylePlain target:self action:@selector(addToCalendar)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    self.alarmTimeMinutes = [[NSMutableArray alloc]init];
    [self.alarmTimeMinutes addObjectsFromArray:[NSArray arrayWithObjects:@-1,@0,@5,@15,@30,@60,@120,@1440,@2880,@10080, nil]];


}
-(void)addToCalendar {
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!granted) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Kein Zugriff..." message:@"Die App kann keine Kalenderevents erstellen. Bitte in den Systemeinstellungen unter Datensicherheit den Zugriff erlauben." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = self.calEntry.subject;
            event.startDate = self.calEntry.startDateTime;
            event.endDate = self.calEntry.endDateTime;
            event.location = self.calEntry.room;
            //event.recurrenceRules =;
            event.notes = [NSString stringWithFormat:@"Tutor: %@\n",self.calEntry.tutor];
            
            if(selectedIndex != 0) {
                NSDate *date = [self.calEntry.startDateTime dateByAddingTimeInterval:[[self.alarmTimeMinutes objectAtIndex:selectedIndex]integerValue]*-60];
                EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
                
                event.alarms = [NSArray arrayWithObjects:alarm, nil];
            }
            
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            if(error != nil) {
                NSLog(@"%@",[error description]);
            }
            else {
                SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Erfolgreich" andMessage:@"Der Termin wurde erfolgreich hinzugefügt zum Kalendar."];
                
                [alertView addButtonWithTitle:@"OK"
                                         type:SIAlertViewButtonTypeDefault
                                      handler:^(SIAlertView *alert) {
                                          [self back];
                                      }];
                
                alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                
                [alertView show];
                
            }
        });
    }];
    
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sliderChange:(DKCircularSlider *)sender
{
    selectedIndex = [self.sliderTextValues indexOfObject:[sender getTextValue]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
