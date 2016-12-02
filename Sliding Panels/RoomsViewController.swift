//
//  RoomsViewController.swift
//  Sliding Panels
//
//  Created by qiuhong on 02/12/2016.
//  Copyright © 2016 CETCME. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let kRoomCellScaling: CGFloat = 0.6

class RoomsViewController: UICollectionViewController, PanelTransitionViewController {
    
    var selectedIndexPath: IndexPath?
    
    let rooms = [
        Room(title: "Bikes and Garages", subtitle: "Calling all bike enthusiasts", image: UIImage(named: "bicycle-garage-gray"), color: UIColor(red: 0.2594, green: 0.3019, blue: 0.3367, alpha: 0.7)),
        Room(title: "Great Coffee", subtitle: "Find the best coffee around town", image: UIImage(named: "bell-bills-coffee-gray"), color: UIColor(red: 0.6833, green: 0.4143, blue: 0.1902, alpha: 0.7)),
        Room(title: "Big Ideas", subtitle: "Great minds think alike", image: UIImage(named: "light-bulb-gray"), color: UIColor(red: 1.0, green: 0.7847, blue: 0.4615, alpha: 0.7))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }


    func setupCollectionView() {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * kRoomCellScaling)
        let cellHeight = floor(screenSize.height * kRoomCellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2
        let insetY = (view.bounds.height - cellHeight) / 2
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoomCell
        cell.detailView.room = rooms[indexPath.item]
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.item == scrollIndex {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            selectedIndexPath = indexPath
            controller.room = rooms[indexPath.item]
            present(controller, animated: true, completion: nil)
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            scrollIndex = indexPath.item
        }
        
    }
    
    // MARK: scroll delegate
    
    var scrollIndex: Int = 0  //only can select the middle item
    var endScroll = true
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludeSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex = round(index)
        
        scrollIndex = Int(roundedIndex)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    //MARK: PanelTransitionViewController

    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailView! {
        if let indexPath = selectedIndexPath {
            if let cell = collectionView?.cellForItem(at: indexPath) as? RoomCell {
                return cell.detailView
            }
        }
        return nil
    }
    
}

