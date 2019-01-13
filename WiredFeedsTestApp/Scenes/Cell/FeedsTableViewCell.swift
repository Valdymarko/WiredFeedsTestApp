//
//  FeedsTableViewCell.swift
//  WiredFeedsTestApp
//
//  Created by Володимир Ільків on 1/12/19.
//  Copyright © 2019 Володимр Ільків. All rights reserved.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    
    //  MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var feedsImageView: UIImageView!
    
    public var item : RSSItem! {
        didSet{
            titleLabel.text = item.title
            descriptionLabel.text = item.description
            dateLabel.text = convertDate(date: item.pubDate)
            feedsImageView.image = loadFeedImage(urlString: item.imgUrlString)
        }
    }
    
    private func loadFeedImage(urlString : String) -> UIImage{
        let url = URL(string: urlString)
        if let url = url{
            let data = try! Data(contentsOf: url)
            var image = UIImage(data: data)
            image = resizeImage(image: image!, toTheSize: CGSize(width: 200, height: 150))
            return image!
        }
        return UIImage()
    }
    
    
    private func convertDate(date : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
            
            return dateFormatter.string(from: dt)
        } else {
            return "Unknown date"
        }
        
    }
    
    private func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let frame :CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: frame)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
