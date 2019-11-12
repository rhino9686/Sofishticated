//
//  FishRow.swift
//  FishTank
//
//  Created by Robert Cecil on 10/19/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI



let darkGrey = Color(red: (30/255), green: (30/255), blue: (30/255), opacity: 1.0)



struct FishRow: View {
    var fishProfile : FishProfile
    var body: some View {
            HStack {
               fishProfile.image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 1)
                    )
                Text(fishProfile.name)
                Spacer()
            }
    }
        
}

struct FishRow_Previews: PreviewProvider {
    static var previews: some View {
        FishRow(fishProfile: fishData[0])
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
