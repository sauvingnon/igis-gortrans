//
//  FireBaseService.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.01.2025.
//

import Foundation
import FirebaseAnalytics

class FireBaseService{
    
    public static let shared = FireBaseService()
    private init(){}
    
    // MARK: Задествованные функции
    
    // Функция уведомления была задействована
    func notificationWasUsed(text: String){
        Analytics.logEvent("notificationWasUsed", parameters: [
            "message_text": text,
        ])
    }
    
    // Сканирование было успешно произведено ++
    func scanWasSuccessful(transport_id: String){
        Analytics.logEvent("scanWasSuccessful", parameters: [
            "transport_id": transport_id,
        ])
    }
    
    // Задействована функция "Показать на карте"
    func wasTappedShowOnMap(value: String){
        Analytics.logEvent("wasTappedShowOnMap", parameters: [
            "item": value,
        ])
    }
    
    // MARK: Открытие экранов
    
    // Сканер QR-кодов запущен ++
    func scannerQRWasOpened(){
        Analytics.logEvent("scannerQRWasOpened", parameters: [
            "date_time": Date.now.description,
        ])
    }
    
    // Карта открыта ++
    func mapWasOpened(){
        Analytics.logEvent("mapWasOpened", parameters: [
            "date_time": Date.now.description,
        ])
    }
    
    // Ближайшие остановки открыты ++
    func nearestStopsWasOpened(){
        Analytics.logEvent("nearestStopsWasOpened", parameters: [
            "date_time": Date.now.description,
        ])
    }
    
    // Избранные открыты ++
    func favoritePageWasOpened(){
        Analytics.logEvent("favoritePageWasOpened", parameters: [
            "date_time": Date.now.description,
        ])
    }
    
    // Открыт экран просмотра маршрута ++
    func showRouteViewOpened(name: String){
        Analytics.logEvent("showRouteViewOpened", parameters: [
            "name_route": name
        ])
    }
    
    // Открыт экран просмотра остановки ++
    func showStopViewOpened(name: String){
        Analytics.logEvent("showStopViewOpened", parameters: [
            "stop_name": name,
        ])
    }
    
    // Открыт экран юнита транспорта ++
    func showUnitViewOpened(name: String){
        Analytics.logEvent("showUnitViewOpened", parameters: [
            "name_transport": name,
        ])
    }
    
    // MARK: Основные события
    
    // Запуск приложения ++
    func appWasLaunch(){
        Analytics.logEvent("appWasLaunch", parameters: [
            "date_time": Date.now.description,
        ])
    }
    
    // Отображение первого запуска, отправка версии ОС, и названия устройства. ++
    func firstLaunch(){
        
        let deviceInfo = collectDeviceInfo()
        
        Analytics.logEvent("firstLaunch", parameters: [
            "device_model": deviceInfo.deviceModel,
            "system_name": deviceInfo.systemName,
            "system_version": deviceInfo.systemVersion,
            "app_version": deviceInfo.appVersion,
            "app_build": deviceInfo.appBuild
        ])
    }
    
}
