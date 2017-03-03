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

class PlayViewController: UIViewController, UIScrollViewDelegate {
    var imageView: UIImageView!
    var voiceUrl: String?
    var isPlaying: Bool = false
    var player = AVPlayer()
    // your player.currentItem.status
    var playerCurrentItemStatus: AVPlayerItemStatus = .unknown
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    //var test: String?
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    var imageList: [ImageSource] = []
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         // Show indicatior
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setSlideShow()
        
        if playerCurrentItemStatus == .readyToPlay {
            activityIndicator.stopAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isPlaying = false
        
        player.pause()
        player.replaceCurrentItem(with: nil)
        // to process when user clicked back button
        if (self.isMovingFromParentViewController){
            //
        }
    }
    
    @IBAction func pushPlayBtn(_ sender: Any) {
        isPlaying = true
        player.play()
    }
    @IBAction func pushBackwardBtn(_ sender: Any) {
        var currentTime: Float64 = CMTimeGetSeconds(player.currentTime())
        currentTime -= 10.0
        player.seek(to: CMTimeMakeWithSeconds(currentTime, Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
        updateAudioProgressView()
    }
    
    @IBAction func pushForwardBtn(_ sender: Any) {
         var currentTime: Float64 = CMTimeGetSeconds(player.currentTime())
        currentTime += 10.0
        player.seek(to: CMTimeMakeWithSeconds(currentTime, Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        updateAudioProgressView()
    }
    
    func setSlideShow() {
        slideShow.backgroundColor = UIColor.white
        slideShow.slideshowInterval = 0
        slideShow.pageControlPosition = PageControlPosition.underScrollView
        slideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideShow.pageControl.pageIndicatorTintColor = UIColor.black
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideShow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // try out other sources such as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideShow.setImageInputs(imageList)
    }
    
    func configureView() {
        let playerItem = AVPlayerItem(url: NSURL(string: voiceUrl!) as! URL)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
        let currentTime = Float(CMTimeGetSeconds(player.currentTime()))
        let duration = Float(CMTimeGetSeconds((player.currentItem?.asset.duration)!))
        // Update progress
        progressSlider.setValue(Float(currentTime/duration), animated: false)
        player.pause()
        playerCurrentItemStatus = playerItem.status
    }
    
    func updateAudioProgressView() {
        if isPlaying {
            let currentTime = Float(CMTimeGetSeconds(player.currentTime()))
            let duration = Float(CMTimeGetSeconds((player.currentItem?.asset.duration)!))
            // Update progress
            progressSlider.setValue(Float(currentTime/duration), animated: true)
        }
    }
}
