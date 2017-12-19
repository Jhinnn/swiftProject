//
//  LocationManager.swift
//  WYP
//
//  Created by 你个LB on 2017/3/8.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import CoreLocation


typealias callcurrentCityFunc = (String, Int) -> Void

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    
    var currentLocation: CLLocation!
    var currentCity: String?
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    /// 创建位置对象
    public var locationManager = CLLocationManager()
    
    private var citySource: [CityModel]?
    
    /// 初始化方法
    static let shared = LocationManager()
    
    /// 私有化inti方法
    override init() {
        let path: String = Bundle.main.path(forResource: "cityList.json", ofType: nil)!
        // 处理文件
        guard let data = try? Data.init(contentsOf: URL(fileURLWithPath: path)) else {
            print("获取文件data失败")
            return
        }
        let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        citySource = [CityModel].deserialize(from: jsonString) as? [CityModel]
    }
    
    // 开始更新地址
    public func starUpdatingLocation() {
        // 设置代理对象
        locationManager.delegate = self
        
        //定位精确度（最高）一般有电源接入，比较耗电
        //kCLLocationAccuracyNearestTenMeters;//精确到10米
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //设备移动后获得定位的最小距离（适合用来采集运动的定位）
        locationManager.distanceFilter = 50
        
        //弹出用户授权对话框，使用程序期间授权（ios8后)
        //requestAlwaysAuthorization;//始终授权
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //获取最新的坐标
        currentLocation = locations.last!
        longitude = currentLocation.coordinate.longitude
        //获取纬度
        latitude = currentLocation.coordinate.latitude
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemark, error) in
            if error == nil {
                let city = placemark?.last?.locality
                self.currentCity = city?.replacingOccurrences(of: "市", with: "")
                UserDefaults.standard.set(self.currentCity ?? "北京", forKey: "cityName")
                
                for city: CityModel in self.citySource! {
                    if city.cityName == self.currentCity {
                        UserDefaults.standard.set(city.cityId ?? "110100", forKey: "cityId")
                    }
                }
            } else {
                print("获取当前位置失败")
            }
        }
        
    }
}

