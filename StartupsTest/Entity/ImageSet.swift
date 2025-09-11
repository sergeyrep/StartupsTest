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
}

enum ImageSetConteiner: String {
  case telegram
  case imageq
}

enum ImageSetCollection: String {
  case left
  case imagec
  case image1
  case imageColl
  case showall
}

struct ImageSetData: Identifiable {
  var id = UUID()
  var image: ImageSetConteiner
}

struct Collection: Identifiable {
  var id = UUID()
  var title: String
  var image: ImageSetCollection
}

protocol ImageSetProtocol {
    var rawValue: String { get }
}

extension Image {
  init<T: ImageSetProtocol>(_ name: T) {
    self.init(name.rawValue)
  }
}

extension ImageSetCollection: ImageSetProtocol {}
extension ImageSetConteiner: ImageSetProtocol {}
extension ImageSet: ImageSetProtocol {}

extension ImageSetData {
  static let mock: [ImageSetData] = [
    ImageSetData(image: .imageq),
    ImageSetData(image: .telegram),
  ]
}

extension Collection {
  static let mock: [Collection] = [
    Collection(title: "New Popular Arrivals", image: .imagec),
    Collection(title: "Mixed Flowers", image: .image1),
    Collection(title: "Thank you", image: .imageColl),
  ]
}
