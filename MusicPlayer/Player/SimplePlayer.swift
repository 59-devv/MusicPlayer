//
//  SimplePlayer.swift
//  MusicPlayer
//
//  Created by 59 on 2022/03/05.
//

import UIKit
import AVFoundation

class SimplePlayer {
    
    // 싱글톤 객체 만들기
    // 하나로 앱 전반에서 돌려 사용하는 것
    static let shared = SimplePlayer()

    private let player = AVPlayer()
    
    // 현재 재생 시간 구하기
    var currentTime: Double {
        return player.currentItem?.currentTime().seconds ?? 0
    }
    
    // 음원의 총 길이 구하기
    var totalDurationTime: Double {
        return player.currentItem?.duration.seconds ?? 0
    }
    
    // 재생중인지 구하기
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    // currentItem 구하기
    var currentItem: AVPlayerItem? {
        return player.currentItem
    }
    
    init() {
    }
    
    // 일시정지
    func pause() {
        player.pause()
    }
    
    // 재생
    func play() {
        player.play()
    }
    
    // 해당 시간으로 곡 재생하기
    func seek(to time:CMTime) {
        player.seek(to: time)
    }
    
    // 재생중인 음악 바꾸기
    func replaceCurrentItem(with item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    // TimeObserver 세팅
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
        player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
}
