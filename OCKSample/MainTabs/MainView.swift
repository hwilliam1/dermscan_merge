//
//  MainView.swift
//  OCKSample
//
//  Created by Corey Baker on 11/25/20.
//  Copyright © 2020 Network Reconnaissance Lab. All rights reserved.
// swiftlint:disable:next line_length
// This was built using tutorial: https://www.hackingwithswift.com/books/ios-swiftui/creating-tabs-with-tabview-and-tabitem

import SwiftUI
import CareKit
import CareKitStore
import CareKitUI
import UIKit

// This file is the SwiftUI equivalent to UITabBarController in setupTabBarController() in SceneDelegate.swift
struct RoundedRectangleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      configuration.label.foregroundColor(.white)
      Spacer()
    }
    .padding()
    .background(Color.purple.cornerRadius(8))
    .scaleEffect(configuration.isPressed ? 0.95 : 1)
  }
}

struct MainView: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.storeManager) private var storeManager
    @Environment(\.tintColor) private var tintColor
    @Environment(\.careKitStyle) private var style
    @Environment(\.userProfileViewModel) private var profileViewModel
    @StateObject var userStatus = UserStatus()
    @State private var selectedTab = 0
    @State private var isShowingProfile = false
    @State private var isShowingCamera = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LoginView(),
                               isActive: $userStatus.isLoggedOut) {
                    EmptyView()
                }
             
                NavigationLink(destination: ProfileView(),
                               isActive: $isShowingProfile) {
                    EmptyView()
                }
//                NavigationLink(destination: Text("Here is the camera view"),
//                               isActive: $isShowingCamera) {
//                    EmptyView()
//                }
//Camera
                NavigationLink(destination: ScanView(),
                               isActive: $isShowingCamera) {
                    EmptyView()
                }
//Carekit 
                CareView()
                Button("Create New Scan") {
                    self.isShowingCamera = true
                }
                .buttonStyle(RoundedRectangleButtonStyle())
                .background(Color.purple.cornerRadius(8))
                .navigationBarTitle("DermScan")
                .navigationBarItems(
                    trailing:
                        Button("Profile") {
                            self.isShowingProfile = true
                        }
                )
            }
        }
        .environmentObject(userStatus)
        .statusBar(hidden: true)
        .accentColor(Color(tintColor))
        .careKitStyle(Styler())
        }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
