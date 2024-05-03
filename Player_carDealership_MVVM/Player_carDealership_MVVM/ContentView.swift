//
//  ContentView.swift
//  Player_carDealership_MVVM
//

import SwiftUI
import AVFoundation

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
                progress
            }, set: { newValue in
                progress = newValue
                viewModel.setTime(value: newValue)
            }), in: 0...Float(viewModel.maxDuration))
            .padding()
            .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                if let currentTime = viewModel.player?.currentTime {
                    progress = Float(currentTime)
                }
            }
            Text(viewModel.setTimeFormat(duration: Int(progress)) ?? "0:00")
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
