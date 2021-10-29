//
//  ContactsTool.m
//  AppBaseConfig
//
//  Created by mlive on 2021/10/29.
//

#import "ContactsTool.h"

@implementation ContactsTool

+ (void)mm_requestContacts:(void(^)(void))deniedBlock addres:(void(^)(NSArray*))addres{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    deniedBlock();
                });
            }else {
                NSLog(@"成功授权");
                [self openContact:addres];
            }
        }];
    }else if(status == CNAuthorizationStatusRestricted){
        NSLog(@"用户拒绝");
        dispatch_async(dispatch_get_main_queue(), ^{
            deniedBlock();
        });
    }else if (status == CNAuthorizationStatusDenied){
        NSLog(@"用户拒绝");
        dispatch_async(dispatch_get_main_queue(), ^{
            deniedBlock();
        });
    }else if (status == CNAuthorizationStatusAuthorized) { //有通讯录权限-- 进行下一步操作
        [self openContact:addres];
    }
}

+ (void)openContact:(void(^)(NSArray*))responseBlock{

    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    // 如果成功获取返回YES
    NSError *error;
    __block NSMutableArray *addresAry = [NSMutableArray array];
    BOOL isSuccess =  [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
          NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
            NSString *label = labelValue.label;
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue ;
            
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSLog(@"姓名=%@, 电话号码是=%@", nameStr, string);
            NSDictionary *dict = @{@"name":nameStr,@"phone":string};
            [addresAry addObject:dict];
        }
        
        //    *stop = YES; // 停止循环，相当于break；
    }];
    
    if (isSuccess || error) { // 注意： 这里还是子线程
        dispatch_async(dispatch_get_main_queue(), ^{
            responseBlock([addresAry copy]);
        });
    }

}

@end
