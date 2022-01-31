//
//  ScanView.swift
//  dermscan
//
//  Created by Yuandi Zhou on 1/23/22.
//
import SwiftUI


struct ScanView: View  {
    @State var image: Image? = nil
    @State var showCaptureImageView: Bool = false
    @State var buttonText: String = "Take photo"
    var body: some View {
        ZStack {
            VStack {
                Text("This page is for selecting body part")
                Button(action: {
                    self.showCaptureImageView.toggle()
                    buttonText = "Take photo again?"
                }) {
                    Text(buttonText)
                }.zIndex(1)
                
                image?
                    . resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .clipped()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
            }
            if (showCaptureImageView) {
                CaptureImageView(isShown: $showCaptureImageView, image: $image)
                    .navigationBarBackButtonHidden(true)

            }
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
