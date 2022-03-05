//
//  DefaultStyle.swift
//  MusicPlayer
//
//  Created by 59 on 2022/03/05.
//

import UIKit

// 다크모드 대응 시 버튼 컬러를 바꿔주기 위한 설정
public enum DefaultStyle {
    public enum Colors {
        public static let tint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { traitCollction in
                    if traitCollction.userInterfaceStyle == .dark {
                        return .white
                    } else {
                        return .black
                    }
                }
            } else {
                return .black
            }
        }()
    }
}
