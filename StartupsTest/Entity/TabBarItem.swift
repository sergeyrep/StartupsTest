//
//  TabBar.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import Foundation
import SwiftUICore
import SwiftUI

enum TabBarItem: CaseIterable, Identifiable {
  case gifts
  case gift
  case events
  case cart
  case profile
  
  var id: Self { self }
  
  var title: String {
    switch self {
    case .gifts: return "Подарки"
    case .gift: return "Подарок"
    case .events: return "Мероприятия"
    case .cart: return "Корзина"
    case .profile: return "Профиль"
    }
  }
  
  var image: String {
    switch self {
    case .gifts: return ImageSet.Tab.rawValue
    case .gift: return ImageSet.Tab2.rawValue
    case .events: return ImageSet.Tab3.rawValue
    case .cart: return ImageSet.Tab4.rawValue
    case .profile: return ImageSet.Tab5.rawValue
    }
  }
}
