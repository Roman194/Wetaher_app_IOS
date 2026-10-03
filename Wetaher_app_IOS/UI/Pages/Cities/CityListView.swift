//
//  CityListView.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

import SwiftUI

struct CityListView: View {
    @Bindable var cityListVM: CityListViewModel
    
    public init(
        cityListViewModel: CityListViewModel,
    ) {
        cityListVM = cityListViewModel
    }
    
    var body: some View {
        
    }
}
