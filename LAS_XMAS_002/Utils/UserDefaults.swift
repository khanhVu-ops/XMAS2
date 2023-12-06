//
//  UserDefaults.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 13/11/2023.
//

import Foundation

extension UserDefaults {
    private struct Keys {
        static let hasBeenShowNoticeAccessCamera = "kHasBeenShowNoticeAccessCamera"
        static let hasBeenShowNoticeAccessPhoto = "kHasBeenShowNoticeAccessPhoto"
        static let hasBeenShowNoticeAccessMicro = "kHasBeenShowNoticeAccessMicro"
        static let videoCallURL = "kvideocallid"
        static let schedule = "kschedule"
    }
    
    static var hasBeenShowNoticeAccessCamera: Bool {
        get { return standard.bool(forKey: Keys.hasBeenShowNoticeAccessCamera) }
        set { standard.set(newValue, forKey: Keys.hasBeenShowNoticeAccessCamera) }
    }
    
    static var hasBeenShowNoticeAccessPhoto: Bool {
        get { return standard.bool(forKey: Keys.hasBeenShowNoticeAccessPhoto) }
        set { standard.set(newValue, forKey: Keys.hasBeenShowNoticeAccessPhoto) }
    }
    
    static var hasBeenShowNoticeAccessMicro: Bool {
        get { return standard.bool(forKey: Keys.hasBeenShowNoticeAccessMicro) }
        set { standard.set(newValue, forKey: Keys.hasBeenShowNoticeAccessMicro) }
    }
    
    static var videoCallURL: String? {
        get { return standard.string(forKey: Keys.videoCallURL) }
        set { standard.set(newValue, forKey: Keys.videoCallURL) }
    }
    
    static var schedule: Int {
        get { return standard.integer(forKey: Keys.schedule) }
        set { standard.set(newValue, forKey: Keys.schedule) }
    }
}
