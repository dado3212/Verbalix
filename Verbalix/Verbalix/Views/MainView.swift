//
//  MainView.swift
//  Verbalix
//
//  Created by Alex Beals on 11/3/24.
//

import SwiftUI

struct MainView: View {
  var body: some View {
    TabView {
      // List mode
      ListView()
        .tabItem {
          Label("Words", systemImage: "list.bullet")
        }
      
      // Quiz mode
      QuizView()
        .tabItem {
          Label("Quiz", systemImage: "questionmark.circle")
        }
    }
  }
}
