//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 59 on 2022/03/01.
//

import UIKit

class HomeViewController: UIViewController {
    
    let trackManager: TrackManager = TrackManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension HomeViewController: UICollectionViewDataSource {
    // 몇 개를 보여줄지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackManager.tracks.count
    }
    
    // 어떤 셀을 표현할지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = trackManager.track(at: indexPath.item)
        cell.updateUI(item: item)
        return cell
    }
    
    // 헤더뷰를 어떻게 표시할지
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let item = trackManager.todaysTrack else {
                return UICollectionReusableView()
            }
            // HeaderView가 있을 경우
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackCollectionHeaderView", for: indexPath) as? TrackCollectionHeaderView else {
                return UICollectionReusableView()
            }
            header.update(with: item)
            header.tapHandler = { item -> Void in
                //Player View를 띄운다.
                let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
                guard let playerVC = playerStoryboard.instantiateViewController(withIdentifier: "PlayerViewController")
                        as? PlayerViewController else { return }
                // 해당 Header View의 item을 현재 재생곡으로 설정한다.
                playerVC.simplePlayer.replaceCurrentItem(with: item)
                
                self.present(playerVC, animated: true, completion: nil)
            }
            return header
            
        // Header View 없을 때 기본값 설정
        default:
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    // Cell을 클릭 했을 때 무엇을 할지
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Player View를 띄운다.
        let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
        guard let playerVC = playerStoryboard.instantiateViewController(withIdentifier: "PlayerViewController")
                as? PlayerViewController else { return }
        
        // indexPath에 맞는 곡을 찾고, 현재 재생곡으로 설정한다.
        let item = trackManager.tracks[indexPath.item]
        playerVC.simplePlayer.replaceCurrentItem(with: item)
        
        present(playerVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 각 셀의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
        let itemInset: CGFloat = 10
        let width:CGFloat = (collectionView.bounds.width - itemSpacing - itemInset) / 2
        let letterHeight: CGFloat = 60
        let height = (width + letterHeight)
        
        return CGSize(width: width, height: height)
    }
}
