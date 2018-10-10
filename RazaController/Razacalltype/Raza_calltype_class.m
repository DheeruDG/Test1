//
//  Raza_calltype_class.m
//  Raza
//
//  Created by umenit on 9/15/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import "Raza_calltype_class.h"

@implementation Raza_calltype_class
-(NSString*)passaccordingnetwork:(NSDictionary*)datafornetworkval networktype:(NSString*)chkforsimcardparameter chkforsimvle:(NSString*)checkfor_availablenetwork
{
    NSString *whattocall;
    if (([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:0]integerValue]==1)&&([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:1]integerValue]==1)&&([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:2]integerValue]==1))
    {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [[datafornetworkval valueForKey:@"valueof"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if ([[NSString stringWithFormat:@"%@",obj]isEqualToString:@"1"])
             {
                 
                 
                 [arr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
                 
             }
             
             
             
         }];
        if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Minutes"])
        {
            if ( !([chkforsimcardparameter isEqual:@"not found"]))
            {
                //[mainbuttontorazaout addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callMadeViaCarrier";
            }
            else if ( [[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"])
                
            {
                //[mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else if ( [[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"])
                
            {
                // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else
            {
                
                //[row11btn addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
                if ( ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:2]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"]))
                    
                {
                    //[mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                    whattocall=@"callRazaout";
                }
                else
                    // [mainbuttontorazaout addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
                    whattocall=@"showalertofsimcard";
            }
            
            
        }
        else if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Data"])
        {
            if ( ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"]))
                
            {
                // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
                
            }
            else if ( ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"]))
                
            {
                // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
                
            }
            else if ( [[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Minutes"])
                
            {
                if (!([chkforsimcardparameter isEqual:@"not found"])) {
                    
                    //[mainbuttontorazaout addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
                    whattocall=@"callMadeViaCarrier";
                }
                else
                {
                    if ( ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:2]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"]))
                        
                    {
                        //  [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                        whattocall=@"callRazaout";
                        
                    }
                    else
                        //[mainbuttontorazaout addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
                        whattocall=@"showalertofsimcard";
                    
                }
                
            }
            
            
            
            
            
        }
        else if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Wi-Fi"])
        {
            if ( ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"]))
                
            {
                //[mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else if ( ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"]))
                
            {
                //[mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else if ( [[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Minutes"])
                
            {
                if (!([chkforsimcardparameter isEqual:@"not found"]))
                {
                    //[mainbuttontorazaout addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
                    whattocall=@"callMadeViaCarrier";
                }
                else
                {
                    whattocall=@"showalertofsimcard";
                    //  [mainbuttontorazaout addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
        }
        
    }
    else if ((([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:0]integerValue]==1)&&([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:1]integerValue]==1))||(([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:1]integerValue]==1)&&([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:2]integerValue]==1))||(([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:2]integerValue]==1)&&([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:0]integerValue]==1)))
    {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [[datafornetworkval valueForKey:@"valueof"] enumerateObjectsUsingBlock:^(id obj123, NSUInteger idx, BOOL *stop)
         {
             if ([[NSString stringWithFormat:@"%@",obj123]isEqualToString:@"1"])
             {
                 NSLog(@"nkmkj");
                 //[obj123 isEqualToString:@"1"]
                 [arr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
                 
                 
             }
             
             
         }];
        NSLog(@"alldsta%@,%@",datafornetworkval,[[datafornetworkval valueForKey:@"valueof"] objectAtIndex:0]);
        if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Data"]||[[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Wi-Fi"])
        {
            if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"])
            {
                //[mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"])
            {
                // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"])
            {
                // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"])
            {
                //[mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else
            {
                // [mainbuttontorazaout addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callMadeViaCarrier";
            }
            
        }
        else
        {
            // [row11btn addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
            if ( !([chkforsimcardparameter isEqual:@"not found"]))
            {
                //[mainbuttontorazaout addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callMadeViaCarrier";
            }
            else if ( [[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"])
                
            {
                // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else if ( [[[datafornetworkval valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"])
                
            {
                // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else
            {
                //[mainbuttontorazaout addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"showalertofsimcard";
            }
            
        }
        
        
    }
    else if (([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:0]integerValue]==1)||([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:1]integerValue]==1)||([[[datafornetworkval valueForKey:@"valueof"]objectAtIndex:2]integerValue]==1))
    {
        
        NSInteger Aindex1 = [[datafornetworkval valueForKey:@"valueof"] indexOfObject:@"1"];
        // NSLog(@" 1 on  %d",Aindex1);
        if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:Aindex1] isEqual:@"Minutes"])
        {
            NSLog(@"1 on Lan");
            //[mainbuttontorazaout addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
            
            whattocall=@"callMadeViaCarrier";
        }
        else if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:Aindex1] isEqual:@"Data"])
        {
            if ([checkfor_availablenetwork isEqual:@"3"])
            {
                whattocall=@"callRazaout";
                //[mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                whattocall=@"showalertofsimcard";
                //[mainbuttontorazaout addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        else if ([[[datafornetworkval valueForKey:@"name"]objectAtIndex:Aindex1] isEqual:@"Wi-Fi"])
        {
            if ([checkfor_availablenetwork isEqual:@"1"])
            {
                //[mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
                whattocall=@"callRazaout";
            }
            else
            {
                whattocall=@"showalertofsimcard";
                //[mainbuttontorazaout addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
        
        //}
    }
    else
    {
        //NSLog(@"no on");
        //    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
        //                                                      message:@"please select atlease single carrier from setting"
        //                                                     delegate:self
        //                                            cancelButtonTitle:nil
        //                                            otherButtonTitles:@"ok",nil];
        //    
        //    [message show];
        whattocall=@"alertmsg";
    }
    
    return whattocall;
}

//if (([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:0]integerValue]==1)&&([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:1]integerValue]==1)&&([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:2]integerValue]==1))
//{
//    NSMutableArray *arr=[[NSMutableArray alloc]init];
//    [[datafornetwork valueForKey:@"valueof"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//     {
//         if ([[NSString stringWithFormat:@"%@",obj]isEqualToString:@"1"])
//         {
//             
//             
//             [arr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
//             
//         }
//         
//         
//         
//     }];
//    if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Minutes"])
//    {
//        if ( !([chkforsimcard isEqual:@"not found"]))
//        {
//            
//            
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaCarrierrazaout:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaCarrierrazaout:indexPath];
//            
//        }
//        else if ( [[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"])
//            
//        {
//            
//            //[self getcarriercallnotallow];
//            //[self callMadeViaCarrier];
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaCarrierrazaout:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaCarrierrazaout:indexPath];
//            
//        }
//        else if ( [[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"])
//            
//        {
//            
//            //                    [razaoutcall addTarget:self
//            //                                action:@selector(callMadeViaVOIPfromImage:)
//            //                      forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//            
//        }
//        else
//        {
//            
//            //[row11btn addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
//            if ( ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:2]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"]))
//                
//            {
//                
//                //                        [razaoutcall addTarget:self
//                //                                                action:@selector(callMadeViaVOIPfromImage:)
//                //                                      forControlEvents:UIControlEventTouchUpInside];
//                [self callMadeViaVOIPfromImage:indexPath];
//                
//                
//            }
//            else
//                [self showalertofsimcard];
//        }
//        
//        
//    }
//    else if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Data"])
//    {
//        if ( ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"]))
//            
//        {
//            
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//            
//            
//        }
//        else if ( ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"]))
//            
//        {
//            
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//            
//            
//        }
//        else if ( [[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Minutes"])
//            
//        {
//            if (!([chkforsimcard isEqual:@"not found"])) {
//                
//                // [self callMadeViaCarrier];
//                //                        [razaoutcall addTarget:self
//                //                                                action:@selector(callMadeViaCarrierrazaout:)
//                //                                      forControlEvents:UIControlEventTouchUpInside];
//                [self callMadeViaCarrierrazaout:indexPath];
//            }
//            else
//            {
//                if ( ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:2]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"]))
//                    
//                {
//                    //                            [razaoutcall addTarget:self
//                    //                                                    action:@selector(callMadeViaVOIPfromImage:)
//                    //                                          forControlEvents:UIControlEventTouchUpInside];
//                    [self callMadeViaVOIPfromImage:indexPath];
//                    
//                }
//                else
//                    [ self showalertofsimcard];
//            }
//            
//        }
//        
//        
//        
//        
//        
//    }
//    else if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Wi-Fi"])
//    {
//        if ( ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"]))
//            
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//            
//        }
//        else if ( ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"]))
//            
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//            
//        }
//        else if ( [[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Minutes"])
//            
//        {
//            if (!([chkforsimcard isEqual:@"not found"]))
//            {
//                //[self callMadeViaCarrier];
//                //                        [razaoutcall addTarget:self
//                //                                                action:@selector(callMadeViaCarrierrazaout:)
//                //                                      forControlEvents:UIControlEventTouchUpInside];
//                [self callMadeViaCarrierrazaout:indexPath];
//            }
//            else
//            {
//                [self showalertofsimcard];
//            }
//        }
//        
//    }
//    
//}
//else if ((([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:0]integerValue]==1)&&([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:1]integerValue]==1))||(([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:1]integerValue]==1)&&([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:2]integerValue]==1))||(([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:2]integerValue]==1)&&([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:0]integerValue]==1)))
//{
//    NSMutableArray *arr=[[NSMutableArray alloc]init];
//    [[datafornetwork valueForKey:@"valueof"] enumerateObjectsUsingBlock:^(id obj123, NSUInteger idx, BOOL *stop)
//     {
//         if ([[NSString stringWithFormat:@"%@",obj123]isEqualToString:@"1"])
//         {
//             NSLog(@"nkmkj");
//             //[obj123 isEqualToString:@"1"]
//             [arr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
//             
//             
//         }
//         
//         
//     }];
//    NSLog(@"alldsta%@,%@",datafornetwork,[[datafornetwork valueForKey:@"valueof"] objectAtIndex:0]);
//    if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Data"]||[[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Wi-Fi"])
//    {
//        if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"])
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//            
//        }
//        else if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:0]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"])
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//        }
//        else if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"])
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//        }
//        else if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"])
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//        }
//        else
//        {
//            //[self callMadeViaCarrier];
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaCarrierrazaout:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaCarrierrazaout:indexPath];
//            
//        }
//        
//    }
//    else
//    {
//        // [row11btn addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
//        if ( !([chkforsimcard isEqual:@"not found"]))
//        {
//            //[self callMadeViaCarrier];
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaCarrierrazaout:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaCarrierrazaout:indexPath];
//            
//        }
//        else if ( [[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Data"]&& [checkfor_availablenetwork isEqual:@"3"])
//            
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//        }
//        else if ( [[[datafornetwork valueForKey:@"name"]objectAtIndex:[[arr objectAtIndex:1]integerValue]] isEqual:@"Wi-Fi"]&& [checkfor_availablenetwork isEqual:@"1"])
//            
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//        }
//        else
//        {
//            [self showalertofsimcard];
//        }
//        
//    }
//    
//    
//}
//else if (([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:0]integerValue]==1)||([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:1]integerValue]==1)||([[[datafornetwork valueForKey:@"valueof"]objectAtIndex:2]integerValue]==1))
//{
//    
//    NSInteger Aindex1 = [[datafornetwork valueForKey:@"valueof"] indexOfObject:@"1"];
//    // NSLog(@" 1 on  %d",Aindex1);
//    if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:Aindex1] isEqual:@"Minutes"])
//    {
//        NSLog(@"1 on Lan");
//        //  [self callMadeViaCarrier];
//        //                [razaoutcall addTarget:self
//        //                                        action:@selector(callMadeViaCarrierrazaout:)
//        //                              forControlEvents:UIControlEventTouchUpInside];
//        [self callMadeViaCarrierrazaout:indexPath];
//        
//        
//    }
//    else if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:Aindex1] isEqual:@"Data"])
//    {
//        if ([checkfor_availablenetwork isEqual:@"3"])
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//        }
//        else
//        {
//            [self showalertofsimcard];
//        }
//    }
//    
//    else if ([[[datafornetwork valueForKey:@"name"]objectAtIndex:Aindex1] isEqual:@"Wi-Fi"])
//    {
//        if ([checkfor_availablenetwork isEqual:@"1"])
//        {
//            //                    [razaoutcall addTarget:self
//            //                                            action:@selector(callMadeViaVOIPfromImage:)
//            //                                  forControlEvents:UIControlEventTouchUpInside];
//            [self callMadeViaVOIPfromImage:indexPath];
//        }
//        else
//        {
//            [self showalertofsimcard];
//        }
//        
//    }
//    
//    
//    //}
//}
//else
//{
//    //NSLog(@"no on");
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
//                                                      message:@"please select atlease single carrier from setting"
//                                                     delegate:self
//                                            cancelButtonTitle:nil
//                                            otherButtonTitles:@"ok",nil];
//    
//    [message show];
//}
//
//
//
//
-(NSString*)printdatetimeforglobal :(NSString *)datetovalidate
{
    
    NSString *dateString =datetovalidate;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate * timeNotFormatted = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString * timeFormatted = [dateFormatter stringFromDate:timeNotFormatted];
    
    return timeFormatted;
}

-(void)GETRAZAUSERFIRST
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathofplist = [documentsDirectory stringByAppendingPathComponent:@"stock.plist"];
    NSMutableDictionary   *yourMutableDictionary = (NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:pathofplist];
    NSArray *ARRRAZAUSER=[yourMutableDictionary allKeys];
    [RAZA_USERDEFAULTS setObject:ARRRAZAUSER forKey:@"GETRAZAUSER"];
}
-(NSArray*)GETRAZAUSER
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathofplist = [documentsDirectory stringByAppendingPathComponent:@"stock.plist"];
    NSMutableDictionary   *yourMutableDictionary = (NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:pathofplist];
    NSArray *ARRRAZAUSER=[yourMutableDictionary allKeys];
   // [RAZA_USERDEFAULTS setObject:ARRRAZAUSER forKey:@"GETRAZAUSER"];
    return ARRRAZAUSER;
}


@end
