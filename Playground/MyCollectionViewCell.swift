// Copyright © 2026 FinanceCore. All rights reserved.

import UIKit

final class MyCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MyCollectionViewCell"
    private let titleLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        layoutAttributes.size = CGSize(width: 100, height: 100)
//        layoutAttributes.center.x = contentView.frame.size.width / 2
//        layoutAttributes.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
//        layoutAttributes.alpha = 0.2
//
//        return layoutAttributes
//    }
}
