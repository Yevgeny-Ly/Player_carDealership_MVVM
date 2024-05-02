//
//  ContentView.swift
//  Player_carDealership_MVVM
//

import SwiftUI
import AVFoundation

struct Song {
    var name: String
    var artist: String
    var albumArt: String
    var songArt: String
    var audioPath: String
}

class PlayerViewModel: ObservableObject {
    @Published public var maxDuration = 0.0
    @Published public var currentTime = 0.0
    var value = 0
    private var timer: Timer?
    private var player: AVAudioPlayer?
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
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            if currentTime >= maxDuration {
                timer?.invalidate()
            } else {
                currentTime += 1.0
            }
        })
    }
    
    func nextSong() {
        value += 1
        playSong(song: songs[value])
        player?.play()
    }
    
    func previousSong() {
        value -= 1
        playSong(song: songs[value])
        player?.play()
    }
    
    private func playSong(song: Song) {
        guard let audioPath = Bundle.main.path(forResource: song.audioPath, ofType: "mp3") else { return }
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            maxDuration = player?.duration ?? 0.0
            startTimer()
            player?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel = PlayerViewModel()
    @State private var isStateMusicPlayback = false
    @State private var isShowingActionSheet = false
    @State private var isShowingAlert = false
    @State private var progress: Float = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0).fill(Color("basibBackground"))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image(viewModel.songs[viewModel.value].albumArt)
                    Spacer()
                    HStack() {
                        infoSong(song: viewModel.songs[viewModel.value])
                        Spacer()
                        actionSong(song: viewModel.songs[viewModel.value])
                            .padding()
                    }
                    sliderControl
                    playerControl
                    Spacer()
            }
        }
    }
    
    var playerControl: some View {
        HStack {
            Button(action: {
                viewModel.previousSong()
            }) {
                Image(.previousTrackIcon)
            }
            Button(action: {
                isStateMusicPlayback.toggle()
                isStateMusicPlayback ? viewModel.play() : viewModel.stop()
            }) {
                Image(isStateMusicPlayback ? .pauseTrack : .playTrack)
            }
            Button(action: {
                isStateMusicPlayback.toggle()
                viewModel.nextSong()
            }) {
                Image(.nextTrackIcon)
            }
        }
    }
    
    var sliderControl: some View {
        HStack {
            Spacer()
            Slider(value: Binding(get: {
                Double(progress)
            }, set: { newValue in
                progress = Float(newValue)
                viewModel.setTime(value: Float(newValue))
            }), in: 0...viewModel.maxDuration)
            .padding()
            Text(String(format: "%.2f", (viewModel.maxDuration - viewModel.currentTime) / 60).replacingOccurrences(of: ".", with: ":"))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    func actionSong(song: Song) -> some View {
        HStack {
            Button(action: {
                isShowingActionSheet.toggle()
            }) {
                Image(.downloadIcon)
            }
            .actionSheet(isPresented: $isShowingActionSheet, content: {
                ActionSheet(title: Text(song.artist), message: Text("Сохранён в папку Загрузки"))
            })
            Button(action: {
                isShowingAlert.toggle()
            }) {
                Image(.shareIcon)
            }
            .alert(isPresented: $isShowingAlert, content: {
                Alert(title: Text("Поделиться"), message: Text(song.name), primaryButton: .default(Text("Да")), secondaryButton: .default(Text("Нет")))
            })
        }
    }
    
    func infoSong(song: Song) -> some View {
        HStack() {
            Image(song.songArt)
                .padding(.horizontal)
            VStack(alignment: .leading) {
                Text(song.artist)
                    .font(.custom("Inter-Bold", size: 17))
                    .foregroundColor(.white)
                Text(song.name)
                    .font(.custom("Inter-Regular", size: 17))
                    .foregroundColor(.subheadlineText)
            }
        }
    }
}

#Preview {
    ContentView()
}
