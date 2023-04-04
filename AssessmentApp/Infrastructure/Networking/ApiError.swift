//
//  ApiError.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 03/04/2023.
//

import Foundation

enum ApiError: Error {
    case invalidPath
}

extension ApiError {
    
    var description: String {
        switch self {
        case .invalidPath:
            return "Invalid Path"
        }
    }
}
