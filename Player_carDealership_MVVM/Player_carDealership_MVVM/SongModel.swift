//
//  SongModel.swift
//  Player_carDealership_MVVM
//

import SwiftUI

/// Обозначения для передачи данных музыки
struct Song {
    /// Имя песни
    var name: String
    /// Имя артиста
    var artist: String
    /// Картинка альбома
    var albumArt: String
    /// Картинка песни
    var songArt: String
    /// Ссылка на песню
    var audioPath: String
}
