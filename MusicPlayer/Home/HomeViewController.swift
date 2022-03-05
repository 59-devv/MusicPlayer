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
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackCollectionHeaderView", for: indexPath) as? TrackCollectionHeaderView else {
                return UICollectionReusableView()
            }
            
            header.update(with: item)
            header.tapHandler = { item -> Void in
                //Player를 띄운다.
                let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
                guard let playerVC = playerStoryboard.instantiateViewController(withIdentifier: "PlayerViewController")
                        as? PlayerViewController else { return }
                playerVC.simplePlayer.replaceCurrentItem(with: item)
                
                self.present(playerVC, animated: true, completion: nil)
            }
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
        guard let playerVC = playerStoryboard.instantiateViewController(withIdentifier: "PlayerViewController")
                as? PlayerViewController else { return }
        
        let item = trackManager.tracks[indexPath.item]
        playerVC.simplePlayer.replaceCurrentItem(with: item)
        
        present(playerVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
        let itemInset: CGFloat = 10
        let width:CGFloat = (collectionView.bounds.width - itemSpacing - itemInset) / 2
        let letterHeight: CGFloat = 60
        let height = (width + letterHeight)
        
        return CGSize(width: width, height: height)
    }
}
