//
//  CityListView.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

import SwiftUI

struct CityListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var cityListVM: CityListViewModel
    
    public init(
        cityListViewModel: CityListViewModel,
    ) {
        cityListVM = cityListViewModel
    }
    
    var body: some View {
        Text("City list page")
    }
}
