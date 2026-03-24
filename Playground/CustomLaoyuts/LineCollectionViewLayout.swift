// Copyright © 2026 FinanceCore. All rights reserved.

import UIKit

class LineCollectionViewLayout: UICollectionViewFlowLayout {
    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.7
    

    override init() {
        super.init()
        itemSize = CGSize(width: 200, height: 100)
        sectionInset = UIEdgeInsets(top: .zero, left: 30, bottom: .zero, right: 30)
        scrollDirection = .vertical
        minimumLineSpacing = 70
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Метод вызывается при изменении bounds
    // А при скролле как раз смещается bounds, по этому метод и будет вызываться каждый раз на скролл!
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        
        // TODO: Подготовить под это рисунки для layout - чтобы было проще воспринимать атрибуты и расчеты!
        // Нарисовал в тетсрадке - надо будет через это показывать Анасу

        let attributes = super.layoutAttributesForElements(in: rect)
        
//        print("⚠️layoutAttributesForElements")
//        print("layout for rect: \(rect.debugDescription)")
//        print((attributes ?? []).debugDescription)
////        for el in attributes {
////            print(<#T##items: Any...##Any#>)
////        }
        
        
//        var visibleRect = CGRect()
//        visibleRect.origin = collectionView.contentOffset
//        visibleRect.size = collectionView.bounds.size
//        
////        print("visibleRect: \(visibleRect.debugDescription)")
//        
//        attributes?.forEach { cellAttributes in
//            if cellAttributes.frame.intersects(visibleRect) {
//                let distance = abs(cellAttributes.center.x - visibleRect.midX)
//                 // TODO: Что это такое? понять
//                if cellAttributes.indexPath.row == 1 {
//                    print("cellAttributes.center.x \(cellAttributes.center.x)")
//                    print("visibleRect.midX \(visibleRect.midX)")
//                    print("distance \(distance)")
////                    print("normalizedDistance \(normalizedDistance)")
//                }
//                if abs(distance) < activeDistance {
//                    let normalizedDistance = distance / activeDistance
//                    let zoom = 1 + zoomFactor * (1 - normalizedDistance)
//                    cellAttributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
//                    cellAttributes.zIndex = Int(round(zoom))
//                    if cellAttributes.indexPath.row == 1 {
//                        print("zoom \(zoom)\n\n")
//                    }
//                }
//                
//            }
//        }
        
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        for cellAttributes in attributes ?? [] {
            if cellAttributes.frame.intersects(visibleRect) {
                let distance = abs(visibleRect.midY - cellAttributes.center.y)
                cellAttributes.alpha = 0.5
                if distance < activeDistance {
                    let normalizedDisctance = distance / activeDistance
                    let zoom = 1 + zoomFactor * (1 - normalizedDisctance)
                    cellAttributes.alpha = CGFloat(0.5 / (1 * abs(normalizedDisctance)))
                    // 05, но если приближпемся - то увеличиваем до 1
                    cellAttributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                    cellAttributes.zIndex = Int(round(zoom))
                }
            }
        }
        
        
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesForItem(at: itemIndexPath)
        guard let attributes else { return nil }
        attributes.center = CGPoint(x: attributes.center.x + 200, y: attributes.center.y)
        attributes.alpha = 0.1
        
        return attributes
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let collectionView else { return proposedContentOffset }
//        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
//        let verticalCenter = proposedContentOffset.y + (collectionView.bounds.size.height / 2.0)
//        let targetRect = CGRect(
//            x: 0,
//            y: proposedContentOffset.y,
//            width: collectionView.bounds.size.width,
//            height: collectionView.bounds.size.height
//        )
//        
//        let attributes = super.layoutAttributesForElements(in: targetRect)
//        for attribute in attributes ?? [] {
//            let itemVerticalCenter = attribute.center.y
//            if abs(verticalCenter - itemVerticalCenter) < abs(offsetAdjustment) {
//                offsetAdjustment = itemVerticalCenter - verticalCenter
//            }
//        }
//        
//        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
//    }
    
    
}
