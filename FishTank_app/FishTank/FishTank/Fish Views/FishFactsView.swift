//
//  FishFactsView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/25/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct FishFactsView: View {
    @State var fish: FishProfile
    
    let Fact1 = ""
    let Fact2 = "Fish are not great at cuddling"
    
    
    var body: some View {
        
        List {
            Spacer()
            
            FishFactEntryView(fishBreed: fish.breedData!, index: 0)
            Spacer()
            FishFactEntryView(fishBreed: fish.breedData!, index: 1)
            Spacer()
            FishFactEntryView(fishBreed: fish.breedData!, index: 2)
            Spacer()
            FishFactEntryView(fishBreed: fish.breedData!, index: 3)
            
        }
        .navigationBarTitle(" \(fish.breedData!.breedName) Facts")

    }
    

}

struct FishFactEntryView: View {
    var fishBreed: FishBreedData
    var index: Int
    
    var body: some View {
        
        Group {
            if (index == 0 && fishBreed.fishFact1 != nil) {
                VStack {
                    HStack {
                        Text("Fact #1")
                            .fontWeight(.bold).padding(.bottom, 3)
                        Spacer()
                    }
                    Text(fishBreed.fishFact1!)
                }
            }
            
            else if (index == 1 && fishBreed.fishFact2 != nil)  {
                VStack {
                    HStack {
                        Text("Fact #2")
                            .fontWeight(.bold).padding(.bottom, 3)
                        Spacer()
                    }
                    Text(fishBreed.fishFact2!)
                }
            }
                
            else if (index == 2 && fishBreed.fishFact3 != nil)  {
                VStack {
                    HStack {
                        Text("Fact #3")
                            .fontWeight(.bold).padding(.bottom, 3)
                        Spacer()
                    }
                    Text(fishBreed.fishFact3!)
                }
            }
            else if (index == 3 && fishBreed.fishFact4 != nil)  {
                VStack {
                    HStack {
                        Text("Fact #4")
                            .fontWeight(.bold).padding(.bottom, 3)
                        Spacer()
                    }
                    Text(fishBreed.fishFact4!)
                }
            }
                
            else {
                Text("")
            }
        
        }
    }

}



struct FishFactsView_Previews: PreviewProvider {
    static var previews: some View {
        FishFactsView(fish: fishData[1])
    }
}
