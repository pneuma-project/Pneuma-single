//
//  BlueToothManager.m
//  BlueToothTest
//
//  Created by FangLin on 15/12/28.
//  Copyright © 2015年 FangLin. All rights reserved.
//

#import "BlueToothManager.h"
#import "Model.h"
#import "FLWrapJson.h"
#import "UserDefaultsUtils.h"
#import "FLDrawDataTool.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
#import "BlueToothDataModel.h"
typedef enum _TTGState{
    
    stx_h = 0,
    pkt_h,
    etx_e
    
}TTGState;

#define kServiceUUID @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E" //服务的UUID
#define kNotifyUUID @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E" //特征的UUID
#define kReadWriteUUID @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E" //特征的UUID

@interface BlueToothManager ()
{
    BOOL isLinked;
    Model *totalModel;  //当前连接蓝牙模型
}
@property (nonatomic,assign)TTGState state;
@property (nonatomic,strong)NSMutableData *putData;
@property (nonatomic,strong)NSMutableArray * trainDataArr;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation BlueToothManager

-(NSMutableData *)putData
{
    if (!_putData) {
        _putData = [[NSMutableData alloc] init];
    }
    return _putData;
}
-(NSMutableArray *)trainDataArr
{
    if (!_trainDataArr) {
        _trainDataArr = [NSMutableArray array];
    }
    return _trainDataArr;
}
//创建单例类
+(instancetype)getInstance
{
    static BlueToothManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BlueToothManager alloc]init];
        
    });
    return manager;
}

//开始扫描
- (void)startScan
{
    //[LCProgressHUD showLoadingText:@"正在扫描"];
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    _peripheralList = [[NSMutableArray alloc]initWithCapacity:0];
}

//停止扫描
-(void)stopScan
{
    [_manager stopScan];
    [LCProgressHUD hide];
}

//检查蓝牙信息
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn){
        NSLog(@"BLE已打开");
        [central scanForPeripheralsWithServices:nil options:nil];
//        [LCProgressHUD showSuccessText:@"Bluetooth is on!"];
    }else{
        totalModel = nil;
        NSLog(@"蓝牙不可用");
        isLinked = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralDidConnect object:nil userInfo:nil];
        [LCProgressHUD showFailureText:@"Bluetooth is not open!"];
    }
}

//扫描到的设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"发现外围设备....%@===%@----%@",peripheral.name,RSSI,advertisementData);
    if (peripheral == nil) {
        [_peripheralList removeAllObjects];
    }
    if (peripheral.name != nil) {
        if ([peripheral.name isEqualToString:@"nRF52832"]) {
            Model *model = [[Model alloc] init];
            NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
            if (data == nil) {
                model.macAddress = @"";
            }else {
                model.macAddress = [FLDrawDataTool hexStringFromData:data];
            }
            if ([totalModel.macAddress isEqualToString:model.macAddress]) {
                model.isLinking = YES;
                model.peripheral = totalModel.peripheral;
                model.num = totalModel.num;
            }else {
                model.isLinking = NO;
                model.peripheral = peripheral;
                model.num = [RSSI intValue];
            }
            [_peripheralList addObject:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scanDevice" object:@{@"DeviceList":_peripheralList} userInfo:nil];
        }
    }
//    if (peripheral.name != nil) {
//        Model * model = [[Model alloc]init];
//        model.peripheral = peripheral;
//        model.num = [RSSI intValue];
//        //如果 外设数组数量为0 则 直接将 该 model 添加到 外设数组中
//        //如果 外设数组数量不为0 则 用遍历数组 用外设的名称 进行判断 是否 存在于该数组中
//        //如果 外设名称相同  则 只修改 该外设 所对应的 rssi
//        //如果 外设名称不同  则 将此外设 加入到外设数组中
//        if (_peripheralList.count == 0 && ([peripheral.name isEqualToString:@"nRF52832"])) {
//            [self connectPeripheralWith:peripheral];
//            [_peripheralList addObject:model];
//            //[[NSNotificationCenter defaultCenter] postNotificationName:@"scanDevice" object:nil userInfo:nil];
//        }else{
//            BOOL ishave = NO;
//            for (Model * mo in _peripheralList) {
//                if ([mo.peripheral.name isEqualToString:model.peripheral.name]) {
//                    mo.num = model.num;
//                    ishave = YES;
//                    break;
//                }else{
//
//                }
//            }
//            //判断名称是否是设备的默认名称
//            if (ishave == NO && ([peripheral.name isEqualToString:@"nRF52832"])) {
//                [_peripheralList addObject:model];
//                //[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(scanDeivceAction) userInfo:nil repeats:YES];
//            }
//        }
//    }
}

//-(void)scanDeivceAction
//{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"scanDevice" object:nil userInfo:nil];
//}

//获取扫描到设备的列表
-(NSMutableArray *)getNameList
{
    return _peripheralList;
}

//连接设备
-(void)connectPeripheralWith:(Model *)model
{
    totalModel = model;
    NSLog(@"开始连接外围设备...");
    [LCProgressHUD showSuccessText:NSLocalizedString(@"Start connecting peripherals", nil)];
    [_manager connectPeripheral:model.peripheral options:nil];
}

//连接设备失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    totalModel = nil;
    [LCProgressHUD showFailureText:NSLocalizedString(@"Connection failed", nil)];
    isLinked = NO;
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralDidConnect object:nil userInfo:nil];
    [UserDefaultsUtils saveBoolValue:NO withKey:@"isConnect"];
}

//设备断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    totalModel = nil;
    isLinked = NO;
    [LCProgressHUD showFailureText:NSLocalizedString(@"Peripheral disconnect", nil)];
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralDidConnect object:nil userInfo:nil];
    [UserDefaultsUtils saveBoolValue:NO withKey:@"isConnect"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(autoConnectAction) userInfo:nil repeats:YES];
}

//自动连接通知
-(void)autoConnectAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"autoConnect" object:nil userInfo:nil];
}

//连接设备成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [LCProgressHUD showSuccessText:NSLocalizedString(@"Connection succeeded", nil)];
    NSLog(@"连接到%@成功  %ld",peripheral.name,(long)peripheral.state);
    isLinked = YES;
    _per = peripheral;
    [_per setDelegate:self];
    [_per discoverServices:nil];
    [UserDefaultsUtils saveBoolValue:YES withKey:@"isConnect"];
    [self.timer invalidate];
}


//扫描设备的服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"发现可用服务...");
    if (error){
        NSLog(@"扫描%@的服务发生的错误是：%@",peripheral.name,[error localizedDescription]);

    }else{
        for (CBService * ser in peripheral.services)
        {
            [_per discoverCharacteristics:nil forService:ser];
        }
    }
}

//扫描服务的特征值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"已发现可用特征...");
    if (error){
        NSLog(@"扫描服务：%@的特征值的错误是：%@",service.UUID,[error localizedDescription]);
    }else{
        CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
        CBUUID *notifyUUID = [CBUUID UUIDWithString:kNotifyUUID];
        CBUUID *readWriteUUID = [CBUUID UUIDWithString:kReadWriteUUID];
        if ([service.UUID isEqual:serviceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.UUID isEqual:notifyUUID]) {
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
                if ([characteristic.UUID isEqual:readWriteUUID]) {
                    _char = characteristic;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectSucceed object:self userInfo:nil];
                }
            }
        }
    }
}

//获取特征值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error){
        NSLog(@"获取特征值%@的错误为%@",characteristic.UUID,error);

    }else{
        NSLog(@"特征值：%@  value：%@",characteristic.UUID,characteristic.value);
        _responseData = characteristic.value;
        [self showResult];
    }
}

//扫描特征值的描述
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error){
        NSLog(@"搜索到%@的Descriptors的错误是：%@",characteristic.UUID,error);

    }else{
        NSLog(@"characteristic uuid:%@",characteristic.UUID);

        for (CBDescriptor * d in characteristic.descriptors){
            NSLog(@"Descriptor uuid:%@",d.UUID);

        }
    }
}

//获取描述值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    if (error){
        NSLog(@"获取%@的描述的错误是：%@",peripheral.name,error);
    }else{
        NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
    }
}

//像蓝牙发送信息
- (void)sendDataWithString:(NSData *)data
{
    if (_char == nil) {
        return;
    }
    [_per writeValue:data forCharacteristic:_char type:CBCharacteristicWriteWithoutResponse];

}

//展示蓝牙返回的信息
-(void)showResult
{
    if (_responseData) {
        NSLog(@"读取到特征值：%@",_responseData);
        NSData *data = _responseData;
        Byte *bytes = (Byte *)[data bytes];
        Byte newByte[data.length];
        for (NSInteger i = 0; i < data.length; i++) {
            newByte[i] = bytes[i];
        }
//        Byte newByte[] = {0xFD,0x01,0x3A,0x01,0x55,0x21,0x16,0x01,0x01,0x19,0x01,0x01,0x02,0x05,0x0A,0x10,0x16,0x1A,0x20,0x22,0x28,0x2A,0x30,0x35,0x3D,0x40,0x4A,0x4B,0x47,0x40,0x38,0x37,0x30,0x2A,0x22,0x15,0x10,0x0A,0x07,0x06,0x03,0x02,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xAB};
//        NSData *data = [NSData dataWithBytes:newByte length:62];
        if (newByte[0] == 0xfd) {
            _state = pkt_h;
        }
        switch (_state) {
            case stx_h:
            {
                if (newByte[data.length - 1] == 0xab) {
                    Byte middleByte[data.length - 2];
                    for (NSInteger j = 0; j<data.length - 2; j++) {
                        
                        middleByte[j] = newByte[j+1];
                    }
                    NSData *newData = [NSData dataWithBytes:middleByte
                                                     length:sizeof(middleByte)];
                    NSLog(@"newdata = %@",newData);
                    _state = etx_e;
                    self.putData = nil;
                }else if (newByte[data.length - 1] != 0xab){
                    [self.putData appendData:data];
//                    NSLog(@"*******%@",self.putData);
                    _state = pkt_h;
                }
            }
                break;
            case pkt_h:
            {
                if (newByte[data.length - 1] == 0xab) {
                    [self.putData appendData:data];
//                    NSLog(@"~~~~~%@",self.putData);
                    Byte *putDataByte = (Byte *)[self.putData bytes];
                    Byte newbt[self.putData.length-2];
                    for (NSInteger j = 0; j<self.putData.length - 2; j++) {
                        newbt[j] = putDataByte[j+1];
                    }
                    NSData *newData = [NSData dataWithBytes:newbt
                                                     length:sizeof(newbt)];
                    NSLog(@"newdata = %@",newData);
                    NSInteger type = [FLDrawDataTool NSDataToNSInteger:[newData subdataWithRange:NSMakeRange(0, 1)]];
                    if (type == 2) {//历史数据
                        [BlueWriteData confirmCodeHistoryData];
                        NSString *medicineName = [FLWrapJson getMedicineNameToInt:[newData subdataWithRange:NSMakeRange(2, 2)]];
//                        NSString *timeStamp = [FLWrapJson dataToNSStringTime:[newData subdataWithRange:NSMakeRange(3, 7)]];
                        NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[FLDrawDataTool NSDataToNSInteger:[newData subdataWithRange:NSMakeRange(4, 4)]]];
                        NSString *sprayData = [FLWrapJson dataToNSString:[newData subdataWithRange:NSMakeRange(8, 50)]];
                        NSString *sumData = [FLWrapJson dataSumToNSString:[newData subdataWithRange:NSMakeRange(8, 50)]];
                        //时间戳转时间
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateStyle:NSDateFormatterMediumStyle];
                        [formatter setTimeStyle:NSDateFormatterShortStyle];
                        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
                        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                        NSArray * historyArr = [[SqliteUtils sharedManager] selectHistoryBTInfo];
                        if (historyArr.count > 0) {
                            for (BlueToothDataModel * model in historyArr) {
                                NSLog(@"<<< %@ >>>", model.timestamp);
                                if ([timeStamp isEqualToString:model.timestamp]) {
                                    return;
                                }
                            }
                        }
                        //插入历史数据表
                        [self insertHistoryDb:@[timeStamp,sprayData,sumData,confromTimespStr,medicineName]];
                    }else if (type == 3){//训练数据
                        [BlueWriteData confirmCodePresentData];
//                        NSString *timeStamp = [FLWrapJson dataToNSStringTime:[newData subdataWithRange:NSMakeRange(3, 7)]];
                        NSString *sprayData = [FLWrapJson dataToNSString:[newData subdataWithRange:NSMakeRange(8, 50)]];
//                        NSString *sumData = [FLWrapJson dataSumToNSString:[newData subdataWithRange:NSMakeRange(8, 50)]];
//                        [self.trainDataArr addObject:sprayData];
                        NSArray *mutArr = [UserDefaultsUtils valueWithKey:@"trainDataArr"];
                        NSMutableArray *newArr = [NSMutableArray arrayWithArray:mutArr];
                        [newArr addObject:sprayData];
                        [UserDefaultsUtils saveValue:newArr forKey:@"trainDataArr"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];
                    }else if (type == 1){//当前实时喷雾
                        NSLog(@"newData = %ld",newData.length);
                        [BlueWriteData confirmCodePresentData];
//                        NSString *timeStamp = [FLWrapJson dataToNSStringTime:[newData subdataWithRange:NSMakeRange(3, 7)]];
                        NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[FLDrawDataTool NSDataToNSInteger:[newData subdataWithRange:NSMakeRange(4, 4)]]];
                        NSString *sprayData = [FLWrapJson dataToNSString:[newData subdataWithRange:NSMakeRange(8, 50)]];
                        NSString *sumData = [FLWrapJson dataSumToNSString:[newData subdataWithRange:NSMakeRange(8, 50)]];
                        //------------------------------//
                        NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
                        int  userId = 0;
                        NSString * name;
                        if (arr.count!=0) {
                            for (AddPatientInfoModel * model in arr) {
                                if (model.isSelect == 1) {
                                    userId = model.userId;
                                    name = model.name;
                                    continue;
                                }
                            }
                        }
                        NSString * sql = [NSString stringWithFormat:@"insert into RealTimeBTData(userid,nowtime,btData,sumBtData) values('%d','%@','%@','%@');",userId,timeStamp,sprayData,sumData];
                        //药品名称
                        NSString *medicineName = [FLWrapJson getMedicineNameToInt:[newData subdataWithRange:NSMakeRange(2, 2)]];
                        //当前读取数据的时间
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                        NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
                        NSString * confromTimespStr2 = [formatter stringFromDate:confromTimesp2];
                        NSString * sql1 = [NSString stringWithFormat:@"insert into historyBTDb(userid,nowtime,btData,sumBtData,date,userName,medicineName) values('%d','%@','%@','%@','%@','%@','%@');",userId,timeStamp,sprayData,sumData,confromTimespStr2,name,medicineName];
                        [[SqliteUtils sharedManager]insertRealBTInfo:sql];
                        [[SqliteUtils sharedManager]insertHistoryBTInfo:sql1];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSprayView" object:nil userInfo:nil];
                    }else if (type == 5) { //
                        NSString *medicineInfo = [FLWrapJson getMedicineInfo:[newData subdataWithRange:NSMakeRange(2, 2)] AndDrugInjectionTime:[newData subdataWithRange:NSMakeRange(4, 4)] AndDrugExpirationTime:[newData subdataWithRange:NSMakeRange(8, 4)] AndDrugOpeningTime:[newData subdataWithRange:NSMakeRange(12, 4)] AndVolatilizationTime:[newData subdataWithRange:NSMakeRange(16, 4)]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMedicineInfo" object:@{@"medicineInfo":medicineInfo} userInfo:nil];
                    }
                    _state = etx_e;
                    self.putData = nil;
                }else if (newByte[data.length - 1] != 0xab){
                    [self.putData appendData:data];
//                    NSLog(@"------%@",self.putData);
                    _state = pkt_h;
                }
            }
                break;
            case etx_e:
                break;
            default:
                break;
        }
    }else{
        NSLog(@"未发现特征值.");
    }
}

//隐藏HUD
- (void)hideHUD {
    
    [LCProgressHUD hide];
}

//打开通知
-(void)openNotify
{
    [_per setNotifyValue:YES forCharacteristic:_readChar];
}

//关闭通知
-(void)cancelNotify
{
    [_per setNotifyValue:NO forCharacteristic:_readChar];

}

//断开连接
-(void)cancelPeripheralWith:(CBPeripheral *)per
{
    [_manager cancelPeripheralConnection:_per];
    
}

-(BOOL)connectSucceed
{
    return isLinked;
}



//插入表
-(void)insertHistoryDb:(NSArray *)dataArr
{
    NSArray * userArr = [FLWrapJson requireUserIdFromDb];
    if ([userArr[0] integerValue] == 0) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:@"insert into historyBTDb(userid,nowtime,btData,sumBtData,date,userName,medicineName) values('%d','%@','%@','%@','%@','%@','%@');",[userArr[0] intValue],dataArr[0],dataArr[1],dataArr[2],dataArr[3],userArr[1],dataArr[4]] ;
    
    [[SqliteUtils sharedManager] insertHistoryBTInfo:sql];
    
}

@end
