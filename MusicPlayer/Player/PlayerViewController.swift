//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by 59 on 2022/03/02.
//

import UIKit

class PlayerViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var playControlButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    // Simple Player를 만들고, 프로퍼티 추가하기
    let simplePlayer = SimplePlayer.shared
    
    var timeObserver: Any?
    var isSeeking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTrackInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func beingDrag(_ sender: UISlider) {
        
    }
    
    @IBAction func endDrag(_ sender: UISlider) {
    }
    
    @IBAction func seek(_ sender: UISlider) {
    }
    
    @IBAction func togglePlayButton(_ sender: UIButton) {
        if simplePlayer.isPlaying {
            simplePlayer.pause()
        } else {
            simplePlayer.play()
        }
        
        updatePlayButton()
    }
}

extension PlayerViewController {
    func updateTrackInfo() {
        // 트랙 정보 업데이트
        guard let track = simplePlayer.currentItem?.convertToTrack() else { return }
        thumbnailImageView.image = track.artwork
        titleLabel.text = track.title
        artistLabel.text = track.artist
    }
    
    func updateTintColor() {
//        playControlButton.tintColor = DefaultStyle.Colors.tint
//        timeSlider.tintColor = DefaultStyle.Colors.tint
    }
    
    func updatePlayButton() {
        if simplePlayer.isPlaying {
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        }
    }
}
