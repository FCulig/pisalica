//
//  ShopView.swift
//  edu-app
//
//  Created by Filip Culig on 30.04.2022..
//

import CoreData
import SwiftUI

// MARK: - ShopView -

struct ShopView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ViewModel = .init()

    // MARK: - View components -

    var body: some View {
        ZStack {
            AppImage.houseBackgroundImage.image
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 3)
            ZStack {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        shopItemsPanel
                        Spacer()
                    }
                    Spacer()
                }
                backButton
            }
            .padding(.bottom, 50)
            .padding(.horizontal, 40)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }

    var backButton: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    AppImage.previousButton.image
                        .aspectRatio(contentMode: .fit)
                }
                .frame(height: 70, alignment: .top)

                Spacer()
            }
            .padding(.vertical, 45)
            Spacer()
        }
    }

    var shopItemsPanel: some View {
        ZStack {
            ZStack {
                AppImage.panelBackgroundImage.image

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ], spacing: 25) {
                        ForEach(viewModel.shopItems, id: \.self) { item in
                            ShopItemView(item: item)
                        }
                    }
                }
                .padding(.vertical, 50)
                .padding(.horizontal, 25)
            }
            .padding(.top, 35)
            .padding(.bottom, 15)
            .padding(.leading, 70)
            .padding(.trailing, 25)
        }
        .padding(.horizontal, 50)
        .onLoad { viewModel.getShopItems(context: moc) }
    }
}

// MARK: - Preview -

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
