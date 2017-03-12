//
//  PlayViewController.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 23..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit
import ImageSlideshow
import AVFoundation
import MediaPlayer

class PlayViewController: UIViewController, UIScrollViewDelegate {
    var voiceUrl: String?
    var player = AVPlayer()
    var playerCurrentItemStatus: AVPlayerItemStatus = .unknown // your player.currentItem.status
    var imageSourceList: [ImageSource] = []
    var thumbImage: UIImage?
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var remainTimeLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    
    // properties for Play Audio
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureView()
        // Setup background playing
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch {
            //catching the error.
            print("Error")
            
        }
    }
    
    func updateNowPlayingInfoCenter() {
        let albumArtWork = MPMediaItemArtwork(image: thumbImage!)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle:  "제목" ,
            MPMediaItemPropertyArtist:  "아티스트" ,
            MPMediaItemPropertyArtwork: albumArtWork,
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value:  1.0 )  // 재생 속도
        ]
        
        /*
        let currentTime = Float(CMTimeGetSeconds(player.currentTime()))
        let duration = Float(CMTimeGetSeconds((player.currentItem?.asset.duration) ?? CMTimeMake(0, 0)))
        let remainTime: Float = duration - currentTime
        // Update progress
        MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = createTimeString(time: currentTime)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo![MPMediaItemPropertyPlaybackDuration] = createTimeString(time: remainTime)
 */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSlideShow()
        
        if playerCurrentItemStatus == .readyToPlay {
            activityIndicator.stopAnimating()
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let e = event , e.type == .remoteControl {
            switch e.subtype {
            case .remoteControlPlay:
                player.play()
                playBtn.setImage(UIImage(named: "pauseCircleIcon"), for: UIControlState.normal)
            case .remoteControlPause:
                player.pause()
                playBtn.setImage(UIImage(named: "playCircleIcon"), for: UIControlState.normal)
            case .remoteControlPreviousTrack:
                changeAudioTime(changeTo: -10)
            case .remoteControlNextTrack:
                changeAudioTime(changeTo: +10)
            default:
                break
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player.pause()
        player.replaceCurrentItem(with: nil)
        // to process when user clicked back button
        if (self.isMovingFromParentViewController){
            //
        }
    }
    
    @IBAction func pushPlayBtn(_ sender: Any) {
        if player.rate != 1.0 {
            // Not playing forward, so play.
            if currentTime == duration {
                currentTime = 0.0
            }
            playBtn.setImage(UIImage(named: "pauseCircleIcon"), for: UIControlState.normal)
            player.play()
        }
        else {
            // Playing, so pause.
            playBtn.setImage(UIImage(named: "playCircleIcon"), for: UIControlState.normal)
            player.pause()
        }
    }
    
    @IBAction func pushBackwardBtn(_ sender: Any) {
        changeAudioTime(changeTo: -10)
        updateAudioProgressView()
    }

    @IBAction func pushForwardBtn(_ sender: Any) {
        changeAudioTime(changeTo: +10)
        updateAudioProgressView()
    }
    
    @IBAction func progressSliderValueChanged(_ sender: UISlider) {
        let duration = Float(CMTimeGetSeconds((player.currentItem?.asset.duration)!))
        currentTime = Double(sender.value * duration)
        let seconds: Int64 = Int64(progressSlider.value * duration)
        let targetTime: CMTime = CMTimeMake(seconds, 1)
        
        player.seek(to: targetTime)
    }
    
    func setSlideShow() {
        slideShow.backgroundColor = UIColor.white
        slideShow.slideshowInterval = 0
        slideShow.pageControlPosition = PageControlPosition.underScrollView
        slideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideShow.pageControl.pageIndicatorTintColor = UIColor.black
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        imageSourceList.insert(ImageSource(image: thumbImage!), at: 0)
        slideShow.setImageInputs(imageSourceList)
    }
    
    func configureView() {
        let playerItem = AVPlayerItem(url: NSURL(string: voiceUrl!) as! URL)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
        updateAudioProgressView()
        updateNowPlayingInfoCenter()
        player.pause()
        playerCurrentItemStatus = playerItem.status
    }
 
    func updateAudioProgressView() {
        let currentTime = Float(CMTimeGetSeconds(player.currentTime()))
        let duration = Float(CMTimeGetSeconds((player.currentItem?.asset.duration) ?? CMTimeMake(0, 0)))
        let remainTime: Float = duration - currentTime
        // Update progress
        progressSlider.setValue(Float(currentTime/duration), animated: true)
        currentTimeLbl.text = createTimeString(time: currentTime)
        remainTimeLbl.text = "-" + createTimeString(time: remainTime)
    }
    
    func changeAudioTime(changeTo time: Float64) {
        var currentTime: Float64 = CMTimeGetSeconds(player.currentTime())
        currentTime += time
        player.seek(to: CMTimeMakeWithSeconds(currentTime, Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    
// MARK: Convenience
     let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
    
    func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))
        
        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
}
