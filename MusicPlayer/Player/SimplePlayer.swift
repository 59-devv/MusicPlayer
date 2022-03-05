//
//  SimplePlayer.swift
//  MusicPlayer
//
//  Created by 59 on 2022/03/05.
//

import UIKit
import AVFoundation

class SimplePlayer {
    
    // 싱글톤 만들기
    // 하나로 앱 전반에서 돌려 사용하는 것
    static let shared = SimplePlayer()

    private let player = AVPlayer()
    
    var currentTime: Double {
        // 현재 재생 시간 구하기
        return player.currentItem?.currentTime().seconds ?? 0
    }
    
    var totalDurationTime: Double {
        // 음원의 총 길이 구하기
        return player.currentItem?.duration.seconds ?? 0
    }
    
    var isPlaying: Bool {
        // 재생중인지 구하기
        return player.isPlaying
    }
    
    var currentItem: AVPlayerItem? {
        // currentItem 구하기
        return player.currentItem
    }
    
    
    init() {
        
    }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        player.play()
    }
    
    func seek(to time:CMTime) {
        player.seek(to: time)
    }
    
    func replaceCurrentItem(with item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
        player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
}
