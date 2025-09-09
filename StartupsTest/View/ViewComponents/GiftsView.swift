//
//  File.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import Foundation
import SwiftUI

struct GiftsView: View {
  
  @StateObject var viewModel: ViewModel
  
  @FocusState private var isSearchFocused: Bool
  //let actions: () -> Void
  //let prodCollection: [ImageSetCollection] = []
  
  var body: some View {
    ZStack {
      Color.veryLight
        .ignoresSafeArea(.all)
      VStack(spacing: 0) {
        navBar
        title
        events
        collections
        container
      }
    }
  }
  
  private var container: some View {
    VStack(spacing: 0) {
      VStack(spacing: 16) {
        viewAllCategoriesButton
        categoriesView
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 20)
      
      contentView
    }
    .background(Color.white)
    .cornerRadius(16, corners: [.topLeft, .topRight])
    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 24))
  }
  
  private var contentView: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 156))]) {
        ForEach(viewModel.gifts) { item in
          ConteinerButton(gifts: item)
        }
      }
    }
  }
  
  private var viewAllCategoriesButton: some View {
    Button {
      
    } label: {
      Text("View all categories")
        .font(.system(size: 14, weight: .medium))
        .foregroundColor(.dark)
        .padding(.horizontal, 5)
        .padding(.vertical, 12)
        .frame(maxWidth: 145)
    }
    .overlay(
      RoundedRectangle(cornerRadius: 23)
        .stroke(Color.prelight, lineWidth: 1)
    )
  }
  
  private var categoriesView: some View {
    HStack(spacing: 12) {
      categoryButton(title: "Giftboxes")
      categoryButton(title: "For Her")
      categoryButton(title: "Popular")
    }
  }
  
  private func categoryButton(title: String) -> some View {
    Button {
      
    } label: {
      HStack(spacing: 4) {
        Text(title)
          .font(.system(size: 14, weight: .medium))
          .foregroundColor(.dark)
        
        Image(systemName: "chevron.down")
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(.dark)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(.veryLight)
      .cornerRadius(12)
    }
  }
  
  private var events: some View {
    ScrollView(.horizontal) {
      Button(action: {}) {
        Image(ImageSet.Events)
      }
    }
    .padding(EdgeInsets(top: 10, leading: 12, bottom: 0, trailing: 12))
  }
  
  private var title: some View {
    HStack {
      Text("Gifts")
        .font(.system(size: 64, weight: .bold, design: .none))
      
      Spacer()
      
      TextField("", text: $viewModel.searchText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .cornerRadius(16)
        .frame(width: isSearchFocused ? 210:110, height: 42)
        .overlay(
          HStack {
            if viewModel.searchText.isEmpty {
              Image(systemName: "magnifyingglass")
                .foregroundColor(.lightGray)
                .padding(.leading, 8)
              Spacer()
              Text("Search")
                .foregroundColor(.lightGray)
                .padding(.trailing, 8)
            }
          }
        )
        .focused($isSearchFocused)
        .animation(.easeInOut(duration: 0.3), value: isSearchFocused)
        .padding(0)
    }
    .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12))
  }
  
  private var navBar: some View {
    HStack {
      Button {
        viewModel.signOut()
      } label: {
        Image(systemName: "arrow.uturn.backward")
      }
      Spacer()
      HStack {
        Text("Deliver to")
        Image(ImageSet.usa)
        Button {
          
        } label: {
          Text("USD")
          Image(systemName: "chevron.down")
        }
        .foregroundColor(.dark)
        .font(.system(size: 14))
      }
    }
    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 19))
  }
  
  private var collections: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 16) {
        ForEach(viewModel.collection) { item in
          CollButton(coll: item)
            .font(.system(size: 12))
            .foregroundColor(.dark)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 80)
          Spacer(minLength: 0)
        }
        .frame(height: 123)
      }
    }
    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
  }
}
