//
//  AutomobileViewModel.swift
//  Player_carDealership_MVVM
//

import SwiftUI

/// Цены на автомобили
final class AutomobileViewModel: ObservableObject {
    private var price: Price?
    
    var prices: [Price] = [Price(value: 2_189_900), Price(value: 1_889_900), Price(value: 2_189_900)]
}
