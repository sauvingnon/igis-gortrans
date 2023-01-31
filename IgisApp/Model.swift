//
//  Model.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import Foundation

class Model{
    let busArray = [2, 6, 7, 8, 9, 10, 11, 12, 15, 16, 18, 19, 21, 22, 23, 25, 26, 27, 28, 29, 31, 34, 36]
    let trainArray = [1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12]
    let trolleybusArray = [1, 2, 4, 6, 7, 9, 10, 14]
}

enum TypeTransport{
    case bus
    case train
    case trolleybus
    case countryBus
}
