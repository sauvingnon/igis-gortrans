//
//  Errors.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 29.08.2023.
//

import Foundation

class Exception{
    static func throwError(message: String){
        debugPrint(message)
        print(message)
        var nullVar: String?
        _ = nullVar!
    }
}
