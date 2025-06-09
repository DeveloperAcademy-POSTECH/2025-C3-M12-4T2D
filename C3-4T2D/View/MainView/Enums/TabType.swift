//
//  TabType.swift
//  C3-4T2D
//
//  Created by bishoe on 5/31/25.
//
import Foundation

enum TabType: Int, CaseIterable {
    case line = 0
    case list = 1
    case heart = 2 // grid에서 heart로 변경

    var activeImage: String {
        switch self {
        case .line: return "line_on"
        case .list: return "list_on"
        case .heart: return "grid_on" 
        }
    }

    var inactiveImage: String {
        switch self {
        case .line: return "line_off"
        case .list: return "list_off"
        case .heart: return "grid_off"
        }
    }

    func imageName(isSelected: Bool) -> String {
        return isSelected ? activeImage : inactiveImage
    }
}
