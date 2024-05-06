//
//  PlayerViewModel.swift
//  Player_carDealership_MVVM
//

import SwiftUI
import AVFoundation

final class PlayerViewModel: ObservableObject {
    @Published public var maxDuration = 0.0
    @Published public var currentTime = 0.0
    var value = 0
    var player: AVAudioPlayer?
    private var timer: Timer?
    private var song: Song?
    
    var songs: [Song] = [
        Song(name: "Паруса моей любви", artist: "Братья Шахунс", albumArt: "albumPicture", songArt: "songPicture", audioPath: "song"),
        Song(name: "Moskau", artist: "RAMMSTEIN", albumArt: "albumPicture", songArt: "songPicture", audioPath: "songTwo"),
        Song(name: "Inner Light with Bob Moses", artist: "Elderbrook", albumArt: "albumPicture", songArt: "songPicture", audioPath: "songThree")
    ]
    
    public func play() {
        playSong(song: songs[value])
        player?.play()
    }
    
    public func stop() {
        player?.stop()
    }
    
    public func setTime(value: Float) {
        guard let time = TimeInterval(exactly: value) else { return }
        player?.currentTime = time
        currentTime = Double(value)
    }
    
    public func nextSong() {
        value += 1
        playSong(song: songs[value])
        player?.play()
    }
    
    public func previousSong() {
        value -= 1
        playSong(song: songs[value])
        player?.play()
    }
    
    public func setTimeFormat(duration: Int) -> String? {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func playSong(song: Song) {
        guard let audioPath = Bundle.main.path(forResource: song.audioPath, ofType: "mp3") else { return }
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            maxDuration = player?.duration ?? 0.0
            player?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
