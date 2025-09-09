//
//  1.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import SwiftUI
import Combine

struct ConteinerButton: View {
  
  let gifts: ImageSetData
  
  var body: some View {
    Button(action: {}) {
      ZStack {
        Image(gifts.image)
        likeButton
          .padding(EdgeInsets(top: 10, leading: 122, bottom: 122, trailing: 10))
          .padding()
      }
      .frame(width: 156, height: 156)
    }
  }
  
  private var likeButton: some View {
    Button {
      
    } label: {
      Image(ImageSet.fav)
    }
  }
}


