//
//  SettingsView.swift
//  edu-app
//
//  Created by Filip Culig on 03.09.2022..
//

import SwiftUI

// MARK: - SettingsView -

struct SettingsListView: View {
    // MARK: - Private properties -

    @ObservedObject var viewModel: ViewModel

    // MARK: - Initializer -

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body -

    var body: some View {
        settingsList
    }

    var settingsList: some View {
        VStack {
            // TODO: Poseban objekt za svaki setting

            HStack {
                Text("Pozadinska glazba")
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, x: 3, y: 2)
                    .font(.system(size: isTablet ? 35 : 20).weight(.bold))
                Spacer()

                if viewModel.isMusicMuted {
                    Button(action: {
                               viewModel.updateMusicSetting(isMuted: false)
                           },
                           image: AppImage.soundOff.image)
                        .frame(width: 65)
                        .padding(.top, 15)
                        .padding(.leading, isTablet ? 15 : 0)
                } else {
                    Button(action: {
                               viewModel.updateMusicSetting(isMuted: true)
                           },
                           image: AppImage.soundOn.image)
                        .frame(width: 65)
                        .padding(.top, 15)
                        .padding(.leading, isTablet ? 15 : 0)
                }
            }

            HStack {
                Text("Zvučni efekti")
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, x: 3, y: 2)
                    .font(.system(size: isTablet ? 35 : 20).weight(.bold))
                Spacer()

                if viewModel.isSoundEffectMuted {
                    Button(action: {
                               viewModel.updateSoundSetting(isMuted: false)
                           },
                           image: AppImage.soundOff.image)
                        .frame(width: 65)
                        .padding(.top, 15)
                        .padding(.leading, isTablet ? 15 : 0)
                } else {
                    Button(action: {
                               viewModel.updateSoundSetting(isMuted: true)
                           },
                           image: AppImage.soundOn.image)
                        .frame(width: 65)
                        .padding(.top, 15)
                        .padding(.leading, isTablet ? 15 : 0)
                }
            }

            #if DEBUG
                HStack {
                    Text("Debug mode")
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 0, x: 3, y: 2)
                        .font(.system(size: isTablet ? 35 : 20).weight(.bold))
                    Spacer()

                    if viewModel.isDebugMode {
                        Button(action: {
                                   viewModel.updateDebugModeSetting(isDebugMode: false)
                               },
                               image: AppImage.soundOff.image)
                            .frame(width: 65)
                            .padding(.top, 15)
                            .padding(.leading, isTablet ? 15 : 0)
                    } else {
                        Button(action: {
                                   viewModel.updateDebugModeSetting(isDebugMode: true)
                               },
                               image: AppImage.soundOn.image)
                            .frame(width: 65)
                            .padding(.top, 15)
                            .padding(.leading, isTablet ? 15 : 0)
                    }
                }
            #endif

            Spacer()
        }
        .padding(.horizontal, 15)
    }
}

// MARK: - Previews -

// struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(viewModel: .init(settingsService: SettingsServicePreviewMock()))
//    }
// }
