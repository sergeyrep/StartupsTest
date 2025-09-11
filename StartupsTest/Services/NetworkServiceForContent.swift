//
//  NetworkServiceForContent.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import Foundation

extension NetworkService {
  
  func dowloadDataConteiner() async throws -> [ImageSetData] {
    try await Task.sleep(for: .seconds(1))
    return ImageSetData.mock
  }
}
