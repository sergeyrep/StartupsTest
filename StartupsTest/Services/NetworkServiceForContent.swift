//
//  NetworkServiceForContent.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import Foundation

extension NetworkService {
  
  func dowloadDataConteiner() async throws -> [ImageSetData] {
    return ImageSetData.mock
  }
  
  func dowloadDataImage() async throws -> [TabBarItem] {
    return TabBarItem.allCases
  }
}
