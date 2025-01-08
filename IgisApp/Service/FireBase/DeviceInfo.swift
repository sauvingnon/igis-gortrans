//
//  DeviceInfo.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.01.2025.
//

import Foundation
import UIKit

struct DeviceInfo {
    var deviceModel: String
    var systemName: String
    var systemVersion: String
    var appVersion: String
    var appBuild: String
}

func collectDeviceInfo() -> DeviceInfo {
    let deviceModel = UIDevice.current.model // Модель устройства, например "iPhone"
    let systemName = UIDevice.current.systemName // Название операционной системы, например "iOS"
    let systemVersion = UIDevice.current.systemVersion // Версия операционной системы, например "16.0"
    
    // Получение информации о приложении
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
       let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        return DeviceInfo(deviceModel: deviceModel,
                          systemName: systemName,
                          systemVersion: systemVersion,
                          appVersion: appVersion,
                          appBuild: appBuild)
    }
    
    // Возвращаем пустую структуру, если не удалось получить информацию
    return DeviceInfo(deviceModel: deviceModel,
                      systemName: systemName,
                      systemVersion: systemVersion,
                      appVersion: "N/A",
                      appBuild: "N/A")
}
