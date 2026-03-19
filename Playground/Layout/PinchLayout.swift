// Copyright © 2026 FinanceCore. All rights reserved.

import UIKit

final class PinchLayout: UICollectionViewFlowLayout {
    var originalCellCenter: CGPoint?
    var pinchedCellPath: IndexPath?
//        didSet {
//            invalidateLayout() // MARK: При изменении свойств нужно инвалидировать layout - иначе не изменится отображение
        // MARK: Или же можно инвалидировать после всех изменений свойств
//        }

    var pinchedCellCenter: CGPoint?
//        didSet {
//            invalidateLayout()
//        }

    var pinchedCellScale: CGFloat?
//        didSet {
//            invalidateLayout()
//        }

    override init() {
        super.init()
        itemSize = CGSize(width: 200, height: 100)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Прояснить - зачем его вызывать а не для конкретного item???
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach { cellAttributes in
            applyPinchToLayoutAttributes(cellAttributes)
        }
        return attributes
    }

    // Прояснить!
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath) // retrive attributes for concrete item (cell?)
        applyPinchToLayoutAttributes(attributes)
        return attributes
    }
    
    private func applyPinchToLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes?) {
        guard let attributes, let pinchedCellPath, attributes.indexPath == pinchedCellPath else { return }
        
        attributes.transform3D = CATransform3DMakeScale(pinchedCellScale ?? 1, pinchedCellScale ?? 1, 1)
        attributes.center = pinchedCellCenter ?? .zero
        attributes.zIndex = 1
//        attributes.alpha =
    }
}
