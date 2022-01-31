//
//  ProfileView.swift
//  OCKSample
//
//  Created by Corey Baker on 11/24/20.
//  Copyright © 2020 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import CareKitUI
import CareKitStore
import CareKit
import os.log

struct ProfileView: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.userProfileViewModel) var viewModel
    @EnvironmentObject var userStatus: UserStatus
    @State var firstName = ""
    @State var lastName = ""
    @State var birthday = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
    @State private var isShowingCamera = false

    var body: some View {

        VStack {
            
            NavigationLink(destination: ScanView(),
                           isActive: $isShowingCamera) {
                EmptyView()
            }
            
            VStack(alignment: .leading) {
                TextField("First Name", text: $firstName)
                    .padding()
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)

                TextField("Last Name", text: $lastName)
                    .padding()
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
               Text("Picture place holder")
                    .padding()
                VStack (alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "ruler.fill")
                        Text("Diameter:     4mm")
                    }
                    HStack {
                        Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                        Text("Symmetrical:     Yes")
                    }
                    HStack {
                        Image(systemName: "eyedropper.halffull")
                        Text("Color:     Single")
                    }
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Discomfort:     None")
                    }
                }
                .padding()
                Button("Add a New Scan") {
                    self.isShowingCamera = true
                }
                .buttonStyle(RoundedRectangleButtonStyle())
                .background(Color.purple.cornerRadius(8))
                
                VStack {
                Text("Next Scan Due On")
                Text("3:30PM Feb 4, 2022")
                }
                .padding()
                
                VStack {
                    Text("Scanning History")
                    Text("Picture place holder")
                }
                .padding()
            }

//                DatePicker("Birthday", selection: $birthday, displayedComponents: [DatePickerComponents.date])
//                    .padding()
//                    .cornerRadius(20.0)
//                    .shadow(radius: 10.0, x: 20, y: 10)
        }

//             Notice that "action" is a closure (which is essentially
//             a function as argument like we discussed in class)

            Button(action: {

                Task {
                    do {
                        try await viewModel.saveProfile(firstName,
                                                        last: lastName,
                                                        birth: birthday)
                    } catch {
                        Logger.profile.error("Error saving profile: \(error.localizedDescription)")
                    }
                }

            }, label: {

                Text("Save Profile")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
            })
            .background(Color(.green))
            .cornerRadius(15)

            // Notice that "action" is a closure (which is essentially
            // a function as argument like we discussed in class)
            Button(action: {
                Task {
                    await viewModel.logout()
                }

            }, label: {

                Text("Log Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
            })
            .background(Color(.red))
            .cornerRadius(15)
            .onReceive(viewModel.$patient, perform: { patient in
            if let currentFirstName = patient?.name.givenName {
                firstName = currentFirstName
            }

            if let currentLastName = patient?.name.familyName {
                lastName = currentLastName
            }

            if let currentBirthday = patient?.birthday {
                birthday = currentBirthday
            }
        }).onReceive(viewModel.$isLoggedOut, perform: { value in
            if self.userStatus.isLoggedOut != value {
                self.userStatus.check()
            }
        }).onAppear(perform: {
            viewModel.refreshViewIfNeeded()
        })
    }


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserStatus(isLoggedOut: false))
    }
}
}
