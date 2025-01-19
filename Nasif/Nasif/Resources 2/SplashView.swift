//
//  SplashView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(.splash)
                .resizable()
                .frame(width: 400, height: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.accent)
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}
