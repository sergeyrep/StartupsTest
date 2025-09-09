//
//  ImageSet.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import Foundation
import SwiftUI

enum ImageSet: String {
  case apple
  case image8
  case Other
  case Vector
  case Tab
  case Tab2
  case Tab3
  case Tab4
  case Tab5
  case Events
  case usa
  case fav
  
  var id: String { rawValue }
}

struct ImageSetData: Identifiable {
  var id = UUID()
  var image: ImageSetConteiner
}

enum ImageSetConteiner: String {
  case telegram
  case imageq
  
  var id: String { rawValue }
}

extension ImageSetData {
  static let mock: [ImageSetData] = [
    ImageSetData(image: .imageq),
    ImageSetData(image: .telegram),
  ]
}

enum ImageSetCollection: String {
  case left
  case imagec
  case image1
  case imageColl
  case showall
  
  var id: String { rawValue }
}

struct Collection: Identifiable {
  var id = UUID()
  var title: String
  var image: ImageSetCollection
}

extension Collection {
  static let mock: [Collection] = [
    Collection(title: "New Popular Arrivals", image: .imagec),
    Collection(title: "Mixed Flowers", image: .image1),
    Collection(title: "Thank you", image: .imageColl),
  ]
}

extension Image {
  init (_ name: ImageSetCollection) {
    self.init(name.rawValue)
  }
}

extension Image {
  init (_ name: ImageSetConteiner) {
    self.init(name.rawValue)
  }
}


extension Image {
  init(_ name: ImageSet) {
    self.init(name.rawValue)
  }
}

