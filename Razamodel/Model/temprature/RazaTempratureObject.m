//
//  RazaTempratureObject.m
//  forcasting
//
//  Created by umenit on 8/8/16.
//  Copyright © 2016 test. All rights reserved.
//

#import "RazaTempratureObject.h"

@implementation RazaTempratureObject
@synthesize CurrentImage,currentTemprature,currentName,currentTempraturefahrenheit,weatherTypeName;
-(id)initWithTempratue:(NSString*)currenticon andtemprature:(NSString*)temprature  andnameofcity:(NSString*)nameofcity andcurrentTempraturefahrenheit:(NSString*)foreginehighttemp weatherTypeName:(NSString*)weatherTypeString
{
    self=[super init];
    if (self) {
        weatherTypeName=weatherTypeString;
        currentName=nameofcity;
         CurrentImage=currenticon;
         currentTemprature=temprature;
        currentTempraturefahrenheit=foreginehighttemp;
    }
    return self;
}
-(UIView*)Returnview:(RazaTempratureObject*)baseobject
{
    UIView *navview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    navview.backgroundColor=[UIColor clearColor];
  //  NSString *IMG=[NSString stringWithFormat:@"%@%@.png",BASEIMAGEWEATHER,baseobject.CurrentImage];
    UIImageView *tempimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];
    //tempimage.image=[UIImage imageNamed:baseobject.CurrentImage];
     // [tempimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",BASEIMAGEWEATHER,baseobject.CurrentImage]]placeholderImage:[UIImage imageNamed:@"sidebaricon.png"] options:SDWebImageContinueInBackground];
    //[tempimage sd_setImageWithURL:[NSURL URLWithString:baseobject.CurrentImage]placeholderImage:[UIImage imageNamed:@"weather.png"] options:SDWebImageContinueInBackground];we
    [[Razauser SharedInstance] downloadImageWithURL:[NSURL URLWithString:baseobject.CurrentImage] completionBlock:^(BOOL succeeded, UIImage *image) {
        tempimage.image=image;
    }];
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 50, 25)];
    if ([[[NSUserDefaults standardUserDefaults]
          stringForKey:Razatempraturemode] length])
    fromLabel.text = [NSString stringWithFormat:@"%d%@",[baseobject.currentTempraturefahrenheit intValue],@"\u00B0"];
   else
       fromLabel.text = [NSString stringWithFormat:@"%d%@",[baseobject.currentTemprature intValue],@"\u00B0"];
    fromLabel.textColor=[UIColor whiteColor];
    [fromLabel setFont: [UIFont fontWithName:@"Helvetica-Bold" size:20]];
    UILabel *fromLabelCITY = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 110, 20)];
   baseobject.currentName = (baseobject.currentName.length >13) ? [baseobject.currentName substringToIndex:13] : baseobject.currentName;
    fromLabelCITY.text = baseobject.currentName;
    fromLabelCITY.textAlignment = NSTextAlignmentCenter;
    fromLabelCITY.textColor=[UIColor whiteColor];
    [fromLabelCITY setFont: [UIFont fontWithName:@"Helvetica" size:11]];
  [navview addSubview:tempimage];
    [navview addSubview:fromLabel];
    [navview addSubview:fromLabelCITY];
    return navview;
}
-(void)setlocationmapsidebar:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey  callback:(void (^)(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error))callback
{
    
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
   
    NSString *basestring=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@/%@.json",apikey,latitude,longitude];
    NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
  
//    
//    //@"http://api.openweathermap.org/data/2.5/weather?lat=28.7040592&lon=77.10249019999999&APPID=84acc7704b496ce56917299e934b8ca6&units=metric"
//    [manager POST:strapi
//       parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             
//              NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//              
//      
//              RazaTempratureObject *baseobject;
////
//              if ([result objectForKey:@"current_observation"]) {
//                  NSString *basedict=[[result objectForKey:@"current_observation"] objectForKey:@"temp_c"];
//                  NSString *basedictForenhight=[[result objectForKey:@"current_observation"] objectForKey:@"temp_f"];
//                  
//                  NSString *basedict2;
//                  if ([latitude isEqualToString:@"USA"]) {
//                    basedict2=@"USA";
//                  }
//                  else
//                   basedict2=[[[result objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"state_name"];
//                   NSString *basedict3=[[result objectForKey:@"current_observation"] objectForKey:@"icon_url"];
//            
//                  baseobject=[[RazaTempratureObject alloc]initWithTempratue:basedict3 andtemprature:basedict andnameofcity:basedict2 andcurrentTempraturefahrenheit:basedictForenhight];
//                   [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:baseobject] forKey:Razatempratureuser];
//                callback(baseobject,[self Returnview:baseobject], nil);
//                  NSLog(@"%@---%@----%@",basedict,basedict2,basedict3);
//              }
//              else
//              callback(baseobject,[self Returnview:baseobject], nil);
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"Error: %@", [error description]);
//              callback(nil,nil, error);
//          }
//     ];
//
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:strapi];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
             callback(nil,nil, error);
        } else {
           // NSLog(@"%@ %@", response, responseObject);
            NSDictionary *result = responseObject;//[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            
            
            RazaTempratureObject *baseobject;
            //
            if ([result objectForKey:@"current_observation"]) {
                NSString *basedict=[[result objectForKey:@"current_observation"] objectForKey:@"temp_c"];
                NSString *basedictForenhight=[[result objectForKey:@"current_observation"] objectForKey:@"temp_f"];
                
                NSString *basedict2;
                if ([latitude isEqualToString:@"USA"]) {
                    basedict2=@"USA";
                }
                else
                    basedict2=[[[result objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"state_name"];
                NSString *basedict3=[[result objectForKey:@"current_observation"] objectForKey:@"icon_url"];
                NSString *basedict4=[[result objectForKey:@"current_observation"] objectForKey:@"weather"];

                baseobject=[[RazaTempratureObject alloc]initWithTempratue:basedict3 andtemprature:basedict andnameofcity:basedict2 andcurrentTempraturefahrenheit:basedictForenhight weatherTypeName:basedict4];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:baseobject] forKey:Razatempratureuser];
                callback(baseobject,[self Returnview:baseobject], nil);
                NSLog(@"%@---%@----%@",basedict,basedict2,basedict3);
            }
            else
                callback(baseobject,[self Returnview:baseobject], nil);
        }
    }];
    [dataTask resume];
}
-(void)setlocationmapsidebarself:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey  callback:(void (^)(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error))callback
{
    NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/%@,%@.json",latitude,longitude];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/28.562559,77.237834.json"
//    NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/%@,%@.json",latitude,longitude];
//    // NSString *strapi=@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/USA/Washington,DC.json";
//    //=======currect api for l,ocatipn
//     // NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@,%@.json",apikey,latitude,longitude];
//   // NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@/%@.json",apikey,latitude,longitude];
//    //NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
//    /*0---------ends-------*/
//   // NSString *basestring=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@/%@.json",apikey,latitude,longitude];
//  //  NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
//    // NSString *strapi=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=metric",latitude,longitude,apikey];
//    
//    //@"http://api.openweathermap.org/data/2.5/weather?lat=28.7040592&lon=77.10249019999999&APPID=84acc7704b496ce56917299e934b8ca6&units=metric"
//    [manager POST:strapi
//       parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              // NSLog(@"JSON: %@", [responseObject description]);
//              NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//              
//              //description
//              RazaTempratureObject *baseobject;
//              //              if ([[result objectForKey:@"weather"] count]) {
//              //                  NSString *mode= [[[result objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
//              //                  NSLog(@"JSON: %@ --- %@----%@---%@", [[result objectForKey:@"main"] objectForKey:@"temp"],[result objectForKey:@"name"],[result objectForKey:@"weather"] ,mode);//Clouds Rain
//              //                baseobject=[[RazaTempratureObject alloc]initWithTempratue:mode andtemprature:[[result objectForKey:@"main"] objectForKey:@"temp"] andnameofcity:[result objectForKey:@"name"]];
//              //                  callback(baseobject,[self Returnview:baseobject], nil);
//              //              }display_location state_name
//              if ([result objectForKey:@"current_observation"]) {
//                  NSString *basedict=[[result objectForKey:@"current_observation"] objectForKey:@"temp_c"];
//                NSString *basedictForenhight=[[result objectForKey:@"current_observation"] objectForKey:@"temp_f"];
//                      NSString *basedict2=[[[result objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"state_name"];
//                  NSString *basedict3=[[result objectForKey:@"current_observation"] objectForKey:@"icon_url"];
//                  
//                  baseobject=[[RazaTempratureObject alloc]initWithTempratue:basedict3 andtemprature:basedict andnameofcity:basedict2 andcurrentTempraturefahrenheit:basedictForenhight];
//                  [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:baseobject] forKey:Razatempratureuserself];
//                  callback(baseobject,[self Returnview:baseobject], nil);
//                  NSLog(@"%@---%@----%@",basedict,basedict2,basedict3);
//              }
//              else
//                  callback(baseobject,nil, nil);
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"Error: %@", [error description]);
//              callback(nil,nil, error);
//          }
//     ];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:strapi];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
             callback(nil,nil, error);
        } else {
           // NSLog(@"%@ %@", response, responseObject);
            NSDictionary *result =responseObject; //[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            
            //description
            RazaTempratureObject *baseobject;
            //              if ([[result objectForKey:@"weather"] count]) {
            //                  NSString *mode= [[[result objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
            //                  NSLog(@"JSON: %@ --- %@----%@---%@", [[result objectForKey:@"main"] objectForKey:@"temp"],[result objectForKey:@"name"],[result objectForKey:@"weather"] ,mode);//Clouds Rain
            //                baseobject=[[RazaTempratureObject alloc]initWithTempratue:mode andtemprature:[[result objectForKey:@"main"] objectForKey:@"temp"] andnameofcity:[result objectForKey:@"name"]];
            //                  callback(baseobject,[self Returnview:baseobject], nil);
            //              }display_location state_name
            if ([result objectForKey:@"current_observation"]) {
                NSString *basedict=[[result objectForKey:@"current_observation"] objectForKey:@"temp_c"];
                NSString *basedictForenhight=[[result objectForKey:@"current_observation"] objectForKey:@"temp_f"];
                NSString *basedict2=[[[result objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"state_name"];
                NSString *basedict3=[[result objectForKey:@"current_observation"] objectForKey:@"icon_url"];
                NSString *basedict4=[[result objectForKey:@"current_observation"] objectForKey:@"weather"];

                baseobject=[[RazaTempratureObject alloc]initWithTempratue:basedict3 andtemprature:basedict andnameofcity:basedict2 andcurrentTempraturefahrenheit:basedictForenhight weatherTypeName:basedict4];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:baseobject] forKey:Razatempratureuserself];
                callback(baseobject,[self Returnview:baseobject], nil);
                NSLog(@"%@---%@----%@",basedict,basedict2,basedict3);
            }
            else
                callback(baseobject,nil, nil);
        }
    }];
    [dataTask resume];
}
-(void)setlocationmapsidebarselfonly:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey  callback:(void (^)(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error,NSString *timestring))callback
{
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/28.562559,77.237834.json"
   NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/0cca8d83ac8b1742/geolookup/conditions/q/%@,%@.json",latitude,longitude];
//    // NSString *strapi=@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/USA/Washington,DC.json";
//    //=======currect api for l,ocatipn
//    // NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@,%@.json",apikey,latitude,longitude];
//    // NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@/%@.json",apikey,latitude,longitude];
//    //NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
//    /*0---------ends-------*/
//    // NSString *basestring=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@/%@.json",apikey,latitude,longitude];
//    //  NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
//    // NSString *strapi=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=metric",latitude,longitude,apikey];
//    
//    //@"http://api.openweathermap.org/data/2.5/weather?lat=28.7040592&lon=77.10249019999999&APPID=84acc7704b496ce56917299e934b8ca6&units=metric"
//    [manager POST:strapi
//       parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              // NSLog(@"JSON: %@", [responseObject description]);
//              NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//              
//              //description
//              RazaTempratureObject *baseobject;
//              //              if ([[result objectForKey:@"weather"] count]) {
//              //                  NSString *mode= [[[result objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
//              //                  NSLog(@"JSON: %@ --- %@----%@---%@", [[result objectForKey:@"main"] objectForKey:@"temp"],[result objectForKey:@"name"],[result objectForKey:@"weather"] ,mode);//Clouds Rain
//              //                baseobject=[[RazaTempratureObject alloc]initWithTempratue:mode andtemprature:[[result objectForKey:@"main"] objectForKey:@"temp"] andnameofcity:[result objectForKey:@"name"]];
//              //                  callback(baseobject,[self Returnview:baseobject], nil);
//              //              }display_location state_name
//              if ([result objectForKey:@"current_observation"]) {
//                  NSString *basedict=[[result objectForKey:@"current_observation"] objectForKey:@"temp_c"];
//                  NSString *basedictForenhight=[[result objectForKey:@"current_observation"] objectForKey:@"temp_f"];
//                  NSString *basedict2=[[[result objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"state_name"];
//                  NSString *basedict3=[[result objectForKey:@"current_observation"] objectForKey:@"icon_url"];
//                  
//                  baseobject=[[RazaTempratureObject alloc]initWithTempratue:basedict3 andtemprature:basedict andnameofcity:basedict2 andcurrentTempraturefahrenheit:basedictForenhight];
//                 // [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:baseobject] forKey:Razatempratureuserself];
//                  callback(baseobject,nil, nil);
//                  NSLog(@"%@---%@----%@",basedict,basedict2,basedict3);
//              }
//              else
//                  callback(baseobject,nil, nil);
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"Error: %@", [error description]);
//              callback(nil,nil, error);
//          }
//     ];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:strapi];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
             callback(nil,nil, error,nil);
        } else {
            //NSLog(@"%@ %@", response, responseObject);
            NSDictionary *result;
            if ([responseObject isKindOfClass:[NSDictionary class]])
                result=responseObject;
            else
           result  = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            
            //description
            RazaTempratureObject *baseobject;
            //              if ([[result objectForKey:@"weather"] count]) {
            //                  NSString *mode= [[[result objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
            //                  NSLog(@"JSON: %@ --- %@----%@---%@", [[result objectForKey:@"main"] objectForKey:@"temp"],[result objectForKey:@"name"],[result objectForKey:@"weather"] ,mode);//Clouds Rain
            //                baseobject=[[RazaTempratureObject alloc]initWithTempratue:mode andtemprature:[[result objectForKey:@"main"] objectForKey:@"temp"] andnameofcity:[result objectForKey:@"name"]];
            //                  callback(baseobject,[self Returnview:baseobject], nil);
            //              }display_location state_name
            if ([result objectForKey:@"current_observation"]) {
                NSString *basedict=[[result objectForKey:@"current_observation"] objectForKey:@"temp_c"];
                NSString *basedictForenhight=[[result objectForKey:@"current_observation"] objectForKey:@"temp_f"];
                NSString *basedict2=[[[result objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"city"];//city  state_name
                NSString *basedict3=[[result objectForKey:@"current_observation"] objectForKey:@"icon_url"];
               //NSString *basedicttime  =[[result objectForKey:@"current_observation"] objectForKey:@"observation_time"];
                 NSString *basedicttime  =[[result objectForKey:@"current_observation"] objectForKey:@"local_time_rfc822"];
                NSString *basedict4=[[result objectForKey:@"current_observation"] objectForKey:@"weather"];

//                NSArray *arr = [basedicttime componentsSeparatedByString:@","];
//                if (arr.count>1) {
//                    basedicttime=[arr objectAtIndex:1];
//                    basedicttime = [basedicttime stringByReplacingOccurrencesOfString:@" IST" withString:@""];
//                   
//                }
                baseobject=[[RazaTempratureObject alloc]initWithTempratue:basedict3 andtemprature:basedict andnameofcity:basedict2 andcurrentTempraturefahrenheit:basedictForenhight weatherTypeName:basedict4];
                // [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:baseobject] forKey:Razatempratureuserself];
                callback(baseobject,nil, nil,basedicttime);
                NSLog(@"%@---%@----%@",basedict,basedict2,basedict3);
            }
            else
                callback(baseobject,nil, nil,nil);
        }
    }];
    [dataTask resume];
}
-(void)getCallerInfo:(NSString*)phonenumber  andapikey:(NSString*)apikey  callback:(void (^)(NSDictionary *result))callback
{
    phonenumber= [phonenumber stringByReplacingOccurrencesOfString:@"011" withString: @"+"];
    NSString *basestring=[NSString stringWithFormat:@"http://apilayer.net/api/validate?access_key=%@&number=%@",apikey,phonenumber];
    NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    //NSString *strapi=@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/28.562559,77.237834.json";
//    // NSString *strapi=@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/USA/Washington,DC.json";
//    //=======currect api for l,ocatipn
//    //  NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@,%@.json",apikey,latitude,longitude];
//    /*0---------ends-------*/
//    
//   // http://apilayer.net/api/validate?access_key=c1864e8627657358c7fa4a0557d36d3d&number=+919452986785
//   // NSString *basestring=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@/%@.json",apikey,latitude,longitude];
//     NSString *basestring=[NSString stringWithFormat:@"http://apilayer.net/api/validate?access_key=%@&number=%@",apikey,phonenumber];
//    NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
//    // NSString *strapi=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=metric",latitude,longitude,apikey];
//    
//    //@"http://api.openweathermap.org/data/2.5/weather?lat=28.7040592&lon=77.10249019999999&APPID=84acc7704b496ce56917299e934b8ca6&units=metric"
//    [manager POST:strapi
//       parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              // NSLog(@"JSON: %@", [responseObject description]);
//              NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//              
//                               callback(result);
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             // NSLog(@"Error: %@", [error description]);
//              callback(nil);
//          }
//     ];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:strapi];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
           // NSLog(@"Error: %@", error);
              callback(nil);
        } else {
            if ([responseObject isKindOfClass:[NSDictionary class]])
                    callback(responseObject);
            else
            {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                //
                callback(result);
            }
          
           
           // NSLog(@"%@ %@", response, responseObject);
           
        }
    }];
    [dataTask resume];
}


-(void)getCallerInfofortempdetail:(NSString*)countryname aanstatename:
                        (NSString*)statename andapikey:(NSString*)apikey  callback:(void (^)(NSDictionary *result))callback
{
    NSString *basestring=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/?q=%@,%@&APPID=%@",statename,countryname,apikey];
    NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    //NSString *strapi=@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/28.562559,77.237834.json";
//    // NSString *strapi=@"http://api.wunderground.com/api/0cca8d83ac8b1742/forecast/geolookup/conditions/q/USA/Washington,DC.json";
//    //=======currect api for l,ocatipn
//    //  NSString *strapi=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@,%@.json",apikey,latitude,longitude];
//    /*0---------ends-------*/
//    
//    // http://apilayer.net/api/validate?access_key=c1864e8627657358c7fa4a0557d36d3d&number=+919452986785
//    // NSString *basestring=[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%@/%@.json",apikey,latitude,longitude];
//    NSString *basestring=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/city?q=%@,%@&APPID=%@",statename,countryname,apikey];
//    NSString *strapi=[basestring stringByReplacingOccurrencesOfString:@" " withString: @"_"];
//    // NSString *strapi=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=metric",latitude,longitude,apikey];
//    
//    //@"http://api.openweathermap.org/data/2.5/weather?lat=28.7040592&lon=77.10249019999999&APPID=84acc7704b496ce56917299e934b8ca6&units=metric"
//    [manager POST:strapi
//       parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              // NSLog(@"JSON: %@", [responseObject description]);
//              NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//              
//              callback(result);
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              // NSLog(@"Error: %@", [error description]);
//              callback(nil);
//          }
//     ];
//
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:strapi];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
             callback(nil);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]])
                callback(responseObject);
            else
            {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            
            callback(result);
            }
        }
    }];
    [dataTask resume];
}
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:CurrentImage forKey:@"tempratureicon"];
    [encoder encodeObject:currentTemprature forKey:@"tempraturetemp"];
     [encoder encodeObject:currentTempraturefahrenheit forKey:@"tempraturetempforegin"];
    [encoder encodeObject:currentName forKey:@"tempraturename"];
    [encoder encodeObject:weatherTypeName forKey:@"weatherTypeName"];
   
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    weatherTypeName=[decoder decodeObjectForKey:@"weatherTypeName"];
    CurrentImage = [decoder decodeObjectForKey:@"tempratureicon"];
    currentTemprature= [decoder decodeObjectForKey:@"tempraturetemp"];
      currentTempraturefahrenheit= [decoder decodeObjectForKey:@"tempraturetempforegin"];
    currentName= [decoder decodeObjectForKey:@"tempraturename"];

    
    return self;
}
-(RazaTempratureObject*)Tempobject
{
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:Razatempratureuser];
    RazaTempratureObject *setusernew;
    setusernew = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    return setusernew;
}
-(RazaTempratureObject*)Tempobjectself
{
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:Razatempratureuserself];
    RazaTempratureObject *setusernew;
    setusernew = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    return setusernew;
}
-(UIView*)GetTempratureview:(NSString*)ViewByName andwidthofview:(float)ViewWidth{
    UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 0,ViewWidth, 35)];
    UILabel *lblTitle =[UILabel.alloc initWithFrame:CGRectMake(15, 0, 136, 35)];
    [lblTitle setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:14]];
    [lblTitle setTextColor:OxfordBlueColor];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    lblTitle.text=ViewByName;
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [viewHeader addSubview:lblTitle];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];
    return viewHeader;
}
-(void)setRecentTempratue:(NSArray*)mainArray andkeyof:(NSString*)keyofrecent andindexval:(int)IndexofReceent
{
    NSMutableArray *basearray=[[NSMutableArray alloc]init];
    [basearray addObjectsFromArray:[[NSUserDefaults standardUserDefaults]
                                    objectForKey:keyofrecent]];
    if ([basearray count]<5)
    {
        if (![basearray containsObject:[mainArray objectAtIndex:IndexofReceent]]) {
            
            [basearray insertObject:[mainArray objectAtIndex:IndexofReceent] atIndex:0];
           
            
           // NSArray* reversedArray = [[basearray reverseObjectEnumerator] allObjects];
            
            [[NSUserDefaults standardUserDefaults] setObject:basearray forKey:keyofrecent];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else
    {
        if (![basearray containsObject:[mainArray objectAtIndex:IndexofReceent]]) {
        [basearray insertObject:[mainArray objectAtIndex:IndexofReceent] atIndex:0];
        [basearray removeObjectAtIndex:basearray.count-1];
        // [basearray replaceObjectAtIndex:0 withObject:[mainArray objectAtIndex:IndexofReceent]];
       // [basearray replaceObjectAtIndex:4 withObject:[mainArray objectAtIndex:IndexofReceent]];
       // NSArray* reversedArray = [[basearray reverseObjectEnumerator] allObjects];
        
        [[NSUserDefaults standardUserDefaults] setObject:basearray forKey:keyofrecent];
        //[[NSUserDefaults standardUserDefaults] removeObjectForKey:keyofrecent];
        [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

-(NSString*)getDateDayNight:(NSString*)time
{
    
    // For calculating the current date
    // NSDate *date = [NSDate date];
    
    // Make Date Formatter
    NSString *mode;
    
    // hh for hour mm for minutes and a will show you AM or PM
    NSString *str = time;//[dateFormatter stringFromDate:date];
    // NSLog(@"%@", str);
    
    // Sperate str by space i.e. you will get time and AM/PM at index 0 and 1 respectively
    NSArray *array = [str componentsSeparatedByString:@" "];
    if (array.count==3) {
        
        
        NSArray *arr2=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
        if (arr2.count==2) {
            
            
            NSString *timef=[arr2 objectAtIndex:0];
            NSString *format=[array objectAtIndex:2];
            if (([format isEqualToString:@"PM"]&&(([timef intValue]>=6) && ([timef intValue]<=12)))||([format isEqualToString:@"AM"]&&(([timef intValue]>=1) && ([timef intValue]<=5))) )
                
                mode=@"NIGHT";
            
            
            else if (([format isEqualToString:@"AM"]&&(([timef intValue]>=6) && ([timef intValue]<=12)))|| ([format isEqualToString:@"PM"]&&(([timef intValue]>=1) && ([timef intValue]<=6))) )
                mode=@"DAY";
            
            
            // Now you can check it by 12. If < 12 means Its morning > 12 means its evening or night
        }
    }
    return mode;
}



-(void)checkvalforTemp:(NSString*)phonenumber   callback:(void (^)(NSDictionary *result))callback
{
    
    NSMutableDictionary *dictsecval=[[NSMutableDictionary alloc]init];
    
    if (phonenumber.length>10) {
        
       NSString  *_modenetwork=[self net];
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    //NSString *numberKey = [phoneNumber stringByReplacingOccurrencesOfString:@"00"
    // withString:@"+"];
    //c1864e8627657358c7fa4a0557d36d3d 30782cdad57eb61895cff22e45fde12c
    [baseobj getCallerInfo:phonenumber andapikey:@"30782cdad57eb61895cff22e45fde12c" callback:^(NSDictionary *result) {
        NSString *main=[result valueForKey:@"location"];
        NSString *maincountry=[result valueForKey:@"country_name"];
        maincountry=
        [maincountry stringByReplacingOccurrencesOfString:@"(Republic of)" withString:@""];
        // [maincountry stringByReplacingOccurrencesOfString:@"Republic of" withString:@""];
        //(Republic of)
        if (![result objectForKey:@"error"]) {
            [baseobj getCallerInfofortempdetail:[result valueForKey:@"country_code"] aanstatename:main andapikey:@"a9ee24496f040339dbce7ab60211c0bc" callback:^(NSDictionary *result) {
                if (result) {
                    // NSDictionary *cc=[[NSDictionary alloc]init];
                    // cc=[result valueForKey:@"list"];
                    NSLog(@"%@--%@",[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lon"],[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lat"]);
                    
                    
                    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
                    [baseobj setlocationmapsidebarselfonly:[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lat"] andlongitude:[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lon"] andapikey:@"0cca8d83ac8b1742" callback:^(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error, NSString* timestring) {
                        if (sellerarray) {
                            if (timestring.length) {
                                
                                NSArray *array = [timestring componentsSeparatedByString:@" "];
                                                                if (array.count==6) {
                                    NSString *time=[array objectAtIndex:4];
                                    NSLog(@"%@",time);
                                    
                                    NSString *dateStr = time;
                                    NSArray *array2 = [dateStr componentsSeparatedByString:@":"];
                                    dateStr=[NSString stringWithFormat:@"%@.%@",[array2 objectAtIndex:0],[array2 objectAtIndex:1]];
                                    //                                        // Convert string to date object
                                    //                                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                    //                                      //  [dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
                                    //                                        [dateFormat setDateFormat:@"HH:mm:ss"];
                                    //                                        NSDate *date = [dateFormat dateFromString:dateStr];
                                    //
                                    //
                                    //
                                    //                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                    //                                        [dateFormatter setDateFormat:@"HH.mm"];
                                    //                                        NSString *strCurrentTime = [dateFormatter stringFromDate:date];
                                    
                                    NSLog(@"Check float value: %.2f     %@",[dateStr floatValue],sellerarray.CurrentImage);
                                    if ([sellerarray.CurrentImage containsString:@"rain"])
                                    {
                                       
                                        if ([dateStr floatValue] >= 18.00 || [dateStr floatValue]  <= 6.00){
                                            
                                            NSLog(@"It's night time with rain");
                                            //_tmpmode.image=[UIImage imageNamed:@"weather-night.png"];
                                            [dictsecval setObject:@"rain_night.png" forKey:@"TEMPIMAGE"];
                                        }
                                        else{
                                            
                                            NSLog(@"It's day time with rain");
                                            //  _tmpmode.image=[UIImage imageNamed:@"weather-day.png"];
                                            [dictsecval setObject:@"rain_day.png" forKey:@"TEMPIMAGE"];
                                        }
                                        
                                        //else
                                        //[dictsecval setObject:@"weather-rain.png" forKey:@"TEMPIMAGE"];
                                    }
                                    else if ([sellerarray.CurrentImage containsString:@"cloudy"]){
                                        
                                        if ([dateStr floatValue] >= 18.00 || [dateStr floatValue]  <= 6.00){
                                            
                                            NSLog(@"It's night time with partlycloudy");
                                            //_tmpmode.image=[UIImage imageNamed:@"weather-night.png"];
                                            [dictsecval setObject:@"cloudy_night.png" forKey:@"TEMPIMAGE"];
                                        }
                                        else{
                                            
                                            NSLog(@"It's day time with partlycloudy");
                                            //  _tmpmode.image=[UIImage imageNamed:@"weather-day.png"];
                                            [dictsecval setObject:@"cloudy_day.png" forKey:@"TEMPIMAGE"];
                                        }
                                    }
                                    else if ([sellerarray.CurrentImage containsString:@"clear"] || [sellerarray.CurrentImage containsString:@"sunny"]){
                                        
                                        if ([dateStr floatValue] >= 18.00 || [dateStr floatValue]  <= 6.00){
                                            
                                            NSLog(@"It's night time with partlycloudy");
                                            //_tmpmode.image=[UIImage imageNamed:@"weather-night.png"];
                                            [dictsecval setObject:@"night.png" forKey:@"TEMPIMAGE"];
                                        }
                                        else{
                                            
                                            NSLog(@"It's day time with partlycloudy");
                                            //  _tmpmode.image=[UIImage imageNamed:@"weather-day.png"];
                                            [dictsecval setObject:@"sunny.png" forKey:@"TEMPIMAGE"];
                                        }
                                    }

                                        //partlycloudy
                                   //http://icons.wxug.com/i/c/k/clear.gif
                                    //http://icons.wxug.com/i/c/k/sunny.gif
                                   //http://icons.wxug.com/i/c/k/nt_clear.gif
                                    //http://icons.wxug.com/i/c/k/hazy.gif
                                    //http://icons.wxug.com/i/c/k/partlycloudy.gif
                                     //http://icons.wxug.com/i/c/k/mostlycloudy.gif
                                      //http://icons.wxug.com/i/c/k/rain.gif
                                                                    
                                    
                                    else if ([dateStr floatValue] >= 18.00 || [dateStr floatValue]  <= 6.00){
                                        
                                        NSLog(@"It's night time");
                                        //_tmpmode.image=[UIImage imageNamed:@"weather-night.png"];
                                        [dictsecval setObject:@"night.png" forKey:@"TEMPIMAGE"];
                                    }else{
                                        
                                        NSLog(@"It's day time");
                                      //  _tmpmode.image=[UIImage imageNamed:@"weather-day.png"];
                                        [dictsecval setObject:@"hazy.png" forKey:@"TEMPIMAGE"];
                                    }
                                    
                                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
                                    [dateFormatter setDateFormat:@"HH:mm:ss"];
                                    
                                    NSDate *date = [dateFormatter dateFromString:time];
                                    
                                    [dateFormatter setDateFormat:@"hh:mm a"];
                                    
                                    NSString *formattedDate = [dateFormatter stringFromDate:date];
                                    
                                    [dictsecval setObject:formattedDate forKey:@"TEMPTIME"];
                                                                    
                                    
                                }
                                
                            }
                                                        //[_tmpicon sd_setImageWithURL:[NSURL URLWithString:sellerarray.CurrentImage]placeholderImage:[UIImage imageNamed:@"dweather.png"] options:SDWebImageContinueInBackground];
                            [dictsecval setObject:sellerarray.weatherTypeName forKey:@"weatherTypeName"];

                            [dictsecval setObject:sellerarray.CurrentImage forKey:@"TEMPICON"];
                            NSURL *urluser=[NSURL URLWithString:sellerarray.CurrentImage];
                            [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
                                if (image)
                                {
                                  //  _tmpicon.image =image;
                                    
                                }
                                
                                else
                                {
                                    
                                }
                                    //_tmpicon.image =  [UIImage imageNamed:@"dweather.png"];
                            }];
                            
                            
                            //if (main.length)
                            //_tmplocation.text=[NSString stringWithFormat:@"%@|%@",main,maincountry];//sellerarray.currentName
                            //_tmplocation.text=[NSString stringWithFormat:@"%@,%@",sellerarray.currentName,maincountry];
                            //                                else if (main.length)
                            //                                //_tmplocation.text=[NSString stringWithFormat:@"%@,%@",main,sellerarray.currentName];
                            //                                _tmplocation.text=[NSString stringWithFormat:@"%@,%@",main,maincountry];
                            //else
                            //_tmplocation.text=[NSString stringWithFormat:@"%@| %@",maincountry,_modenetwork];//sellerarray.currentName;_modenetwork
                            
                             [dictsecval setObject:[NSString stringWithFormat:@"%@| %@",maincountry,_modenetwork] forKey:@"TEMPLOCATION"];
                            
//                            if (_tmplocation.text.length>10)
//                                [_tmplocation setFont:[UIFont fontWithName:@"Poppins-Regular" size:14]];
//                            
//                            else
//                                [_tmplocation setFont:[UIFont fontWithName:@"Poppins-Regular" size:25]];
                            if ([[[NSUserDefaults standardUserDefaults]
                                  stringForKey:Razatempraturemode] length])
                             //   _tmptmp.text=[NSString stringWithFormat:@"%d˚F",[sellerarray.currentTempraturefahrenheit intValue]];
                             [dictsecval setObject:[NSString stringWithFormat:@"%d˚F",[sellerarray.currentTempraturefahrenheit intValue]] forKey:@"TEMP"];
                            
                            else
                               // _tmptmp.text=[NSString stringWithFormat:@"%d˚C",[sellerarray.currentTemprature intValue]];
                            [dictsecval setObject:[NSString stringWithFormat:@"%d˚C",[sellerarray.currentTemprature intValue]] forKey:@"TEMP"];
                            
                            callback(dictsecval);
                            //[self settitleview:@"Australia (2222)"];
                        }
                        
                    }];
                    
                }
                else
                {
                    callback(dictsecval);
                }
                
            }];
            
        }
        
    }
     ];
        }
    else
        callback(dictsecval);
}
-(NSString*)net
{
    NSString *netmode;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        //checkfor_availablenetwork=@"0";
        netmode= nil;
    }
    else if (status == ReachableViaWiFi)
    {
        netmode= @"Wifi";
    }
    else if (status == ReachableViaWWAN)
    {
        netmode= @"Data";
    }
    
    return netmode;
    
}


@end
