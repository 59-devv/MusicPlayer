//
//  TrackManager.swift
//  MusicPlayer
//
//  Created by 59 on 2022/03/02.
//

import UIKit
import AVFoundation

class TrackManager {

    // 프로퍼티 정의하기 - 트랙들, 앨범들, 오늘의 곡
    var tracks: [AVPlayerItem] = []
    var albums: [Album] = []
    var todaysTrack: AVPlayerItem?
    
    // 생성자 정의하기
    init() {
        let tracks = loadTracks()
        self.tracks = tracks
        self.albums = loadAlbums(tracks: tracks)
        self.todaysTrack = self.tracks.randomElement()
    }
    
    // 트랙 로드하기
    func loadTracks() -> [AVPlayerItem] {
        // 파일들을 읽어서 AVPlayerItem으로 만들기
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? []
        let items = urls.map { url in
            return AVPlayerItem(url: url)
        }
        return items
    }
    
    // 인덱스에 맞는 트랙 로드하기
    func track(at index: Int) -> Track? {
        let playerItem = tracks[index]
        let track = playerItem.convertToTrack()
        return track
    }
    
    // 앨범 로딩 메서드 구현
    func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
        let trackList: [Track] = tracks.compactMap { item in
            return item.convertToTrack()
        }
        let albumDics = Dictionary(grouping: trackList, by: { track in track.albumName })
        var albums: [Album] = []
        for (key, value) in albumDics {
            let title = key
            let tracks = value
            let album = Album(title: title, tracks: tracks)
            albums.append(album)
        }
        return albums
    }
    
    // 오늘의 트랙 랜덤으로 선택
    func loadOtherTodaysTrack() {
        self.todaysTrack = self.tracks.randomElement()
    }
    
    
}
