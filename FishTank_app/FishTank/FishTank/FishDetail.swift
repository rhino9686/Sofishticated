//
//  FishDetail.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct FishDetail: View {
    @State var fish: FishProfile
    @EnvironmentObject var tankData: TankProfile
    
    @Environment(\.editMode) var mode
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
            }.padding(.trailing).padding(.leading)
            
            FittedImage(image: fish.image, width: 300, height: 300)
            
            Divider()
    
            HStack {
                Text(fish.breedData!.breedName)
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 6)
            .padding(.leading)
            Spacer()
            
            if self.mode?.wrappedValue == .inactive {
               
              } else {
                  Button("Remove from Tank") {
                    self.removeFishFromTank()
                  }
              }
            
        }
        .navigationBarTitle(Text(fish.name))
    }
    
    func removeFishFromTank() {
        
         let myId = self.fish.id
         self.tankData.removeFish(id: myId)
         self.presentationMode.wrappedValue.dismiss()
    }
    
    
    
    
}

struct FittedImage: View
{
    let image: Image
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            image
                .resizable()
                .aspectRatio(1, contentMode: .fill)
        }
        .frame(width: width, height: height)
        .clipShape(
            RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}


struct FishDetail_Previews: PreviewProvider {
    static var previews: some View {
        FishDetail(fish: fishData[1])
        .environmentObject(TankProfile())
    }
}
