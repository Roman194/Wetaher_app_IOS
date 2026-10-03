//
//  SettingsView.swift
//  Wetaher_app_IOS
//
//  Created by Roman Zyuzin on 02.10.2026.
//

import SwiftUI

struct SettingsView: View {
    
    @Bindable var settingsVM: SettingsViewModel

    public init(settingsViewModel: SettingsViewModel) {
        settingsVM = settingsViewModel
    }
    
    var body: some View {
        Text("Settings page")
    }
}
