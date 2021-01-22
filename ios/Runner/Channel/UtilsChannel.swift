//
//  TimezoneHelper.swift
//  Runner
//
//  Created by Apple on 8/18/20.
//

import Foundation

fileprivate let utilsChannelKey = "flutter.tp.utilsNativeChannel"

struct UtilsFuncName {
    static let getCityTimezone = "getCityTimeZone"
    static let getProxyDefault = "getProxyDefault"
    static let cancelAllNotificationTray = "cancelAllNotificationTray"
}

class UtilsChannel {
    static let shared = UtilsChannel()
    
    init() {}
    
    func configChannel(window: UIWindow?) {
        guard let wd = window else { return }
        let controller = wd.rootViewController as! FlutterViewController
        let nativeTZChannel = FlutterMethodChannel(name: utilsChannelKey, binaryMessenger: controller.binaryMessenger)
        nativeTZChannel.setMethodCallHandler {
            [weak self] (call, result) in
            guard let _ = self else { return }
            DispatchQueue.main.async {
                [weak self] in
                guard let wSelf = self else { return }
                switch call.method {
                case UtilsFuncName.getCityTimezone:
                    result(TimeZone.current.identifier)
                case UtilsFuncName.getProxyDefault:
                    result(wSelf.getProxyDefault())
                case UtilsFuncName.cancelAllNotificationTray:
                    wSelf.cancelAllNotificationTray()
                default:
                    break
                }
            }
        }
    }
    
    fileprivate func getProxyDefault() -> String {
        let dicRef = CFNetworkCopySystemProxySettings()
        if let dict = dicRef?.takeRetainedValue() as? [String: Any] {
            let host = dict[kCFNetworkProxiesHTTPProxy as String] as? String ?? ""
            let port = dict[kCFNetworkProxiesHTTPPort as String] as? Int ?? 0
            return "{\"host:\"\(host), \"port:\"\(port)}"
        }
        
        return "";
    }
    
    fileprivate func cancelAllNotificationTray() {
        let userNoti = UNUserNotificationCenter.current()
        userNoti.getDeliveredNotifications {  (notis) in
            for item in notis {
                print(item.request.content.body)
            }
            
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
    }
}
