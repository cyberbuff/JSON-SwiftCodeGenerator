//
//  Utils.swift
//  ZZZZ
//
//  Created by Hare Sudhan on 10/12/17.
//  Copyright © 2017 ZZZZ. All rights reserved.
//

import Foundation

protocol ErrorProtocol {
    
}

enum Result<T,E: ErrorProtocol> {
    case Success(T)
    case Failure(E)
}

enum MEError : ErrorProtocol{
    case parseError
    case other(String)
}

