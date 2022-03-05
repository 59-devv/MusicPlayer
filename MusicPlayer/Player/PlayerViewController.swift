//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by 59 on 2022/03/02.
//

import UIKit
import CoreMedia

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
    
    // 시간을 업데이트 하기 위한 옵저버
    var timeObserver: Any?
    // 재생구간을 찾는 중인지 확인(슬라이더가 움직이고 있는지?)
    var isSeeking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 원래는 아래 두개가 viewWillAppear에 있었는데,
        // 모달창에 손만 갖다대도 이게 실행이 되어서
        // 이 화면이 뜰 때 최초에만 실행되도록 변경하였음
        updateTrackInfo()
        updateTintColor()
        
        // 0.1초
        let intervalTime = CMTime(seconds: 1, preferredTimescale: 10)
        // 0.1초마다 업데이트를 시킬거기 때문에, 메인 쓰레드에게 0.1초마다 알려주겠다는 queue
        // 0.1초마다 시간을 확인해서, updateTime을 시켜준다.
        let queue = DispatchQueue.main
        timeObserver = simplePlayer.addPeriodicTimeObserver(forInterval: intervalTime, queue: queue, using: { time in
            self.updateTime(time: time)
        })
    }
    
    // 원래는 viewWillDisappear 이었는데,
    // 모달창에 손만 대면 아래가 실행되어서
    // viewDidDisappear를 통해 확실하게 모달창이 닫혔을때만 실행하도록 변경
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        simplePlayer.pause()
        simplePlayer.replaceCurrentItem(with: nil)
        
    }
    
    // 드래그 시작했는지?
    @IBAction func beingDrag(_ sender: UISlider) {
        isSeeking = true
        
    }
    
    // 드래그 끝냈는지?
    @IBAction func endDrag(_ sender: UISlider) {
        isSeeking = false
    }
    
    // 재생 구간 찾는 함수
    @IBAction func seek(_ sender: UISlider) {
        // simplePlayer를 통해 현재 재생곡 가져오기
        guard let currentItem = simplePlayer.currentItem else { return }
        
        // slider의 위치
        let position = Double(sender.value)  // 0...1
        // 슬라이더의 현재 위치에 곡의 총 시간을 곱하면
        // 현재 어디를 재생중인지 확인할 수 있다.
        let seconds = position * currentItem.duration.seconds
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        simplePlayer.seek(to: time)
    }
    
    // Play버튼 토글
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
        
        // 아래는 없었는데 추가하였음
        // 처음 화면이 뜰 때 slider를 가장 왼쪽으로
        timeSlider.value = 0
        // 처음 화면이 뜰 때, 0초부터 시작하도록 만들었음
        // 화면을 껐다가 다시 해당 곡을 누르면, 재생했던 곳부터 재생하는 것이 싫어서 바꿨음
        simplePlayer.seek(to: CMTime.zero)
    }
    
    func updateTintColor() {
        playControlButton.tintColor = DefaultStyle.Colors.tint
        timeSlider.tintColor = DefaultStyle.Colors.tint
    }
        
    // 시간 정보 업데이트
    func updateTime(time: CMTime) {
        currentTimeLabel.text = secondsToString(sec: simplePlayer.currentTime)
        totalDurationLabel.text = secondsToString(sec: simplePlayer.totalDurationTime)
        
        if isSeeking == false {
            // 노래를 들으면서 Seeking을 하면, 슬라이더가 이동됨.
            // 따라서 시킹이 아닐 때마다 슬라이더를 자동으로 업데이트 한다.
            timeSlider.value = Float(simplePlayer.currentTime / simplePlayer.totalDurationTime)
        }
    }
    
    // 시간을 String으로 변환하기
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    // Play버튼과 Pause버튼 세팅
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
