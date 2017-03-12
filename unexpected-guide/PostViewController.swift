//
//  PostViewController.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 18..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit
import ImageSlideshow

class PostViewController: UICollectionViewController, StaggeredGridLayoutDelegate {
    var artId: Int?
    var selectedImage: UIImage?
    let requestManager = RequestManager()
    var thumbImage: UIImage?
    var imageList: [UIImage?] = []
    
    var voiceResults = [VoiceData]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = textfieldColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.updateVoiceResults), name: NSNotification.Name(rawValue: "voiceResultsUpdated"), object: nil)
        
        // Get data with artId
        requestManager.searchVoice(artId: artId!)
        
        // Show indicatior
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        
        self.collectionView!.contentInset = UIEdgeInsetsMake(12.0, 5.0, 5.0, 5.0)
        
        let layout: StaggeredGridLayout = self.collectionView!.collectionViewLayout as! StaggeredGridLayout;
        layout.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = backgroundColor
        // to draw rounded cell
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        // to draw shadow effect
        cell.layer.shadowColor = boldFontColor.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.voiceResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! PostCell
        cell.setModel(self.voiceResults[indexPath.item])
        
        return cell
    }
    
    // MARK: - StaggeredGridLayoutDelegate
    
    func heightForProfileViewAtIndexPath(_ collectionView : UICollectionView, indexPath : IndexPath, width : CGFloat) -> CGFloat {
        let post: VoiceData = self.voiceResults[indexPath.item]
        
        if let _ = post.docentId {
            return PostCell.profileViewHeightWithImage(cellWidth: width)
        } else {
            return 0.0
        }
    }
    
    func heightForBodyAtIndexPath(_ collectionView : UICollectionView, indexPath : IndexPath, width : CGFloat) -> CGFloat {
        if (self.voiceResults[indexPath.item].description != nil) && ((self.voiceResults[indexPath.item].description?.characters.count)! > 0) {
            return PostCell.bodyHeightWithText(description, cellWidth:width)
        } else {
            return 0.0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        performSegue(withIdentifier: "toPlayVC", sender: collectionView.cellForItem(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toPlayVC") {
            let playVC: PlayViewController = segue.destination as! PlayViewController
            let selectedItem = sender as! PostCell
            
            playVC.voiceUrl = selectedItem.voiceUrl
            playVC.thumbImage = thumbImage
            for item in imageList {
                playVC.imageSourceList.append(ImageSource(image: item!))
            }
        }
    }

    
    // UTils
    func updateVoiceResults() {
        voiceResults = requestManager.voiceResults
        activityIndicator.stopAnimating()
    }
    
}

