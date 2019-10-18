//
//  DataError.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import Foundation
enum DataError:Error {
    case readCollectionError(String)
    case readSingleError(String)
    case entityExistesError(String)
    case deleteExtityError(String)
    case updateExtityError(String)
    
}
