//
//  LoadingEnum.swift
//  Care4U
//
//  Created by Lisis Ruschel on 30.10.24.
//

import Foundation

enum LoadingStateEnum {
    case idle
    case loading
    case loaded
    case error(Error)
}
