//
//  2.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import SwiftUI

struct CollButton: View {
  
  let coll: Collection
  
  var body: some View {
    Button {
      
    } label: {
      VStack(spacing: 4) {
        Image(coll.image)
        Text(coll.title)
      }
    }
  }
}
