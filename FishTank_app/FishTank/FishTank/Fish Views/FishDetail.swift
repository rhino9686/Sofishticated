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
    @EnvironmentObject var noteCenter: LocalNotificationManager
    
    @Environment(\.editMode) var mode
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
           VStack{
                    
                HStack {
                      if self.mode?.wrappedValue == .active {
                          Button("Cancel") {
                              self.mode?.animation().wrappedValue = .inactive
                          }
                      }
                      
                     Spacer()
                      
                      EditButton()
                }
                .padding(.trailing).padding(.leading)
                
                
                FittedImage(image: fish.image, width: 250, height: 200)
                
                Divider()
        
                HStack {
                    Text("I'm a \(fish.breedData!.breedName)!")
                        .font(.headline)
                    Spacer()
                }
                .padding(.top, 6)
                .padding(.leading)
                Divider()
                HStack {
                    Text("Preferred Living Conditions")
                    Spacer()
                }.padding()
          
                HStack {
                    Text("pH range: ")
                        .font(.callout)
                    
                    Text("\(fish.breedData!.minpHStr) -\(fish.breedData!.maxpHStr)")
                        .font(.footnote)
                    
                    Spacer()
                }
                .padding(.top, 6)
                .padding(.leading)
                
                
                HStack {
                    Text("Temperature range: ")
                        .font(.callout)
                    
                    Group {
                        if self.tankData.inFahrenheight {
                            Text("\(fish.breedData!.minTempStr_F) - \(fish.breedData!.maxTempStr_F) °F")
                                .font(.footnote)
                        }
                        else {
                            
                            Text("\(fish.breedData!.minTempStr_C) - \(fish.breedData!.maxTempStr_C) °C")
                                .font(.footnote)
                        }
                    }

                    
                    Spacer()
                }
                .padding(.top, 6)
                .padding(.leading)
                
                
            ScrollView{
                
                NavigationLink(destination: RemindersView(fish: fish)
                    .environmentObject(self.tankData)
                
                ) {
                HStack {
                     Text("Reminders")
                         .fontWeight(.semibold)
                     Spacer()
                 }
             }.padding(.leading).padding(.top)
                
                NavigationLink(destination: FishFactsView(fish: fish)) {
                    HStack {
                        Text("Breed Facts")
                            .fontWeight(.semibold)
                        Spacer()
                    }
               }.padding(.leading).padding(.top)
            }
                
           //     Spacer()
                
                if self.mode?.wrappedValue == .active {
                      
                         Button("Remove from Tank") {
                           self.removeFishFromTank()
                         }.padding()
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
        
        HStack {
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
            
            Spacer()
        }.padding()

    }
}


struct FishDetail_Previews: PreviewProvider {
    static var previews: some View {
        FishDetail(fish: fishData[1])
        .environmentObject(TankProfile())
        .environmentObject(LocalNotificationManager())
    }
}
