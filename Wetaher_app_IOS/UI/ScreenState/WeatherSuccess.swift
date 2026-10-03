//
//  WeatherSuccess.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 03.10.2026.
//

import SwiftUI

struct WeatherSuccess: View {
    
    @Binding var showSettingsSheet: Bool
    @Binding var showCityListSheet: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    showSettingsSheet = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.body)
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.8))
                        .clipShape(Circle())
                }

                Spacer()

                Button {
                    showCityListSheet = true
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.body)
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.8))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            
            WeatherMainView()
        }
    }
}
