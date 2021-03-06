//
//  GalleryViewController.swift
//  foe_toe_fellows
//
//  Created by nacnud on 1/15/15.
//  Copyright (c) 2015 nacnud. All rights reserved.
//

protocol ImageSelectedProtocol{
    func controllerDidSelectImgae(selectedImage: UIImage) -> Void
}

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource ,UICollectionViewDelegate{
    
    var collectionView : UICollectionView!
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    var images: [UIImage] = []
    var delagate: ImageSelectedProtocol?
    var pinch: UIPinchGestureRecognizer!

    
    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.backgroundColor = UIColor.whiteColor()
        
        //MARK: setup collectionView
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionView  = UICollectionView(frame: CGRectZero, collectionViewLayout: self.collectionViewFlowLayout)
        self.collectionView = UICollectionView(frame: rootView.frame, collectionViewLayout: self.collectionViewFlowLayout)
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionViewFlowLayout.itemSize = CGSize(width: rootView.frame.width/2.35, height: rootView.frame.width/2.35)
        rootView.addSubview(collectionView)
        
        //MARK: setup collectionview constraints
        self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let views = ["collectionView": self.collectionView]
        let colectionViewVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[collectionView]-|", options: nil, metrics: nil, views: views)
        let collectionViewHorizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[collectionView]-|", options: nil, metrics: nil, views: views)
        rootView.addConstraints(colectionViewVerticalConstraint)
        rootView.addConstraints(collectionViewHorizontalConstraint)

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.pinch = UIPinchGestureRecognizer(target: self, action: "pinchGesture:")
        self.collectionView.addGestureRecognizer(self.pinch)
        //MARK: register gallery cell class with reuse identifiers
        self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "CELL")
        
        //MARK: fill images array with astronaut pics
        for (var i = 1; i < 15; i++){
            self.images.append(UIImage(named: "astronaut\(i).jpg")!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: conform to UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as GalleryCell
        cell.imageView.backgroundColor = UIColor.blackColor()
        cell.imageView.image = images[indexPath.row]
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.layer.masksToBounds = true
        return cell
    }
    
    //MARK: cornform to UICollectionViewDelagate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delagate?.controllerDidSelectImgae(images[indexPath.row])
    }
    
    //MARK: get the pinches to wrk
    func pinchGesture(sender: UIPinchGestureRecognizer){
        switch sender.state {
        case .Began:
            println("galery pinch began")
        case .Changed:
            println("galler pinch changed")
        case .Ended:
            println("pinch Ended")
            if self.collectionViewFlowLayout.itemSize.height < self.view.bounds.width / 2 {
                self.collectionView.performBatchUpdates({ () -> Void in
                    if sender.velocity > 0{
                        let largeSize = CGSize(width: self.collectionViewFlowLayout.itemSize.width * 2, height: self.collectionViewFlowLayout.itemSize.height * 2)
                        self.collectionViewFlowLayout.itemSize = largeSize
                    }

                }, completion: { (finished) -> Void in
                    //ah
                })
            } else if collectionViewFlowLayout.itemSize.height > self.view.bounds.width / 4  {
                self.collectionView.performBatchUpdates({ () -> Void in
                    if sender.velocity < 0 {
                        let normalSize = CGSize(width: self.collectionViewFlowLayout.itemSize.width / 2, height: self.collectionViewFlowLayout.itemSize.height / 2)
                        self.collectionViewFlowLayout.itemSize = normalSize
                    }
                }, completion: { (finished) -> Void in
                    // ah
                })
            }
            
        default:
            println("default case")
        }

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
