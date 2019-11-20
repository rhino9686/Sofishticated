//
//  FishDetail.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct FishDetail: View {
    var fish: FishProfile
    
    var body: some View {
        VStack {
            
            FittedImage(image: fish.image, width: 300, height: 300)
            
            Divider()
    
            HStack {
                Text(fish.name)
                    .font(.title)
                Spacer()
            }
            .padding(.top, 6)
            .padding(.leading)
            
            HStack {
                Text(fish.breedData!.breedName)
                    .font(.footnote)
                Spacer()
            }
            .padding(.top, 6)
            .padding(.leading)
            Spacer()
        }.frame(height:600)
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
    }
}
