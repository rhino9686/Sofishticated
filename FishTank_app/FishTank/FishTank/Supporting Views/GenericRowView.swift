//
//  GenericRowView.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct GenericRowView: View {
    var label: String
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
        }
    .padding()
    }
}

struct GenericRowView_Previews: PreviewProvider {
    static var previews: some View {
        GenericRowView(label: "Label")
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
