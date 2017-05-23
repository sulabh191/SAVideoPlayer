//
//  VideoListTableViewCell.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 08/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {

    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var tvRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setVideoListData(_videoData : VideoModel) {
        self.videoTitle.text = _videoData.videoTitle
        self.tvRatingLabel.text = _videoData.videoTvRating
    }
    
}
