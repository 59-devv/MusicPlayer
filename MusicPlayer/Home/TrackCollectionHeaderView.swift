//
//  TrackCollectionHeaderView.swift
//  MusicPlayer
//
//  Created by 59 on 2022/03/02.
//

import UIKit
import AVFoundation

// 헤더뷰 설정
class TrackCollectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: AVPlayerItem?
    var tapHandler: ((AVPlayerItem) -> Void)?
    
    // 이 셀이 실제로 등장할 때 호출되는 메서드
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }
    
    // 헤더뷰 업데이트하기
    func update(with item: AVPlayerItem) {
        self.item = item
        guard let track = item.convertToTrack() else { return }
        self.thumbnailImageView.image = track.artwork
        self.descriptionLabel.text = "Today's pick is \(track.artist)'s album - \(track.albumName), let's listen!"
    }
    
    // 카드를 탭 했을때 처리
    @IBAction func cardTapped(_ sender: UIButton) {
        guard let todaysItem = item else { return }
        tapHandler?(todaysItem)
    }
}
