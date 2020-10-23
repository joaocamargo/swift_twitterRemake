//
//  ProfileFilterView.swift
//  twitterClone
//
//  Created by joao camargo on 27/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "ProfileFilterCell"

protocol ProfileFilterViewDelegate: class {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: Int)
}

class ProfileFilterView: UIView {
    
    //MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underlineView: UIView = {
       let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    weak var delegate: ProfileFilterViewDelegate?
    
    //MARK: - LifeCycle
    override init(frame: CGRect){
        super.init(frame: frame)
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        
        let selectIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectIndexPath, animated: true, scrollPosition: .left)
        
    }
    
    //pra poder acessar o FRAME
    override func layoutSubviews() {
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,width: frame.width/3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - Collectionviewdelegate

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }

        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3){
            self.underlineView.frame.origin.x = xPosition
        }
        
        print("DEBUG: delegate from filter bar")
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}


// MARK: - UICollectionViewDataSource


extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout


extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(ProfileFilterOptions.allCases.count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

}
