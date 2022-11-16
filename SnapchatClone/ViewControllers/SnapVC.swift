//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Berke Topcu on 15.11.2022.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher

class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        
        
        if let snap = selectedSnap {
            
            timeLabel.text = "Time Left \(snap.timeDifference)"
            
            for imageUrl in snap.imageArray {
                /*
                 Kingfisher ve imageslideshow kütüphanelerini ekleyerek birden fazla resmi çekmek için kullandık
                 */
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
        }
        //Imageslideshow için konum ve boyut değerleri verdik.
        let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
        imageSlideShow.backgroundColor = UIColor.white
        //arkaplan rengi ve ekrana sığdırma işlemlerini tamamladık
        //Kaç fotoğraf var kısmını alt bölüme ekledik.
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.black
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        imageSlideShow.pageIndicator = pageIndicator
        
        
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        /*oluşturduğumuz kingfishersource array'ini slideshow'a verdik. Bu array Firestoredaki image array'imizi getirdi */
        imageSlideShow.setImageInputs(inputArray)
        //View'a slider ekledik.
        self.view.addSubview(imageSlideShow)
        self.view.bringSubviewToFront(timeLabel)
        
        
    }
    

  

}
