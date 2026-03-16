// Copyright © 2026 FinanceCore. All rights reserved.

import UIKit

class LineCollectionViewLayout: UICollectionViewFlowLayout {
    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.3
    
    /*
     
      contentOffset  — это свойство  UIScrollView  (а значит и  UICollectionView ), которое описывает, насколько содержимое прокручено относительно его собственной системы координат.
     Связь  contentOffset  и  bounds.origin
     У  UIScrollView  (и наследников) есть особенность:
      contentOffset  всегда равен  bounds.origin , то есть верхний‑левый угол «видимого окна» в системе координат  contentView  задаётся именно через  contentOffset .
     Эквивалентно можно думать так:
         •     bounds  — это «окно», через которое мы смотрим на контент.
         •     bounds.origin  — точка в системе координат контента, которая попадает в верхний‑левый угол этого окна.
         •     contentOffset  — просто удобное имя/alias для этого же значения (только как  CGPoint , без ширины/высоты).
     
     
     TODO: - разобрать что такое видимая область, contentOffset и другие размеры CollectionView
     
     
     TODO: - Хорошо разобрать LayoutAttributes - так как обычно можно мыслить о настройках отображаемого item через это
     */
    
    
    override init() {
        super.init()
        itemSize = CGSize(width: 200, height: 200)
        sectionInset = UIEdgeInsets(top: 200, left: .zero, bottom: 200, right: .zero)
        scrollDirection = .horizontal
        minimumLineSpacing = 50
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        attributes?.forEach { cellAttributes in
            if CGRectIntersectsRect(cellAttributes.frame, rect) {
                let distance = CGRectGetMidX(visibleRect) - cellAttributes.center.x
                let normalizedDistance = distance / activeDistance // TODO: Что это такое? понять
                if abs(distance) < activeDistance {
                    let zoom = 1 + zoomFactor * (1 * abs(normalizedDistance))
                    cellAttributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                    cellAttributes.zIndex = Int(round(zoom))
                }
            }
        }
        
        return attributes
    }
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let collectionView else {
//            return super.layoutAttributesForItem(at: indexPath)
//        }
//        let attributes = super.layoutAttributesForItem(at: indexPath)
//        var visibleRect = CGRect()
//        visibleRect.origin = collectionView.contentOffset
//        visibleRect.size = collectionView.bounds.size
//        
//        if CGRectIntersectsRect(attributes.frame, rect) {
//            let distance = CGRectGetMidX(visibleRect) - attributes.center.x
//            let normalizedDistance = distance / activeDistance // TODO: Что это такое? понять
//            if abs(distance) < activeDistance {
//                let zoom = 1 + zoomFactor * (1 * abs(normalizedDistance))
//                cellAttributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
//                cellAttributes.zIndex = Int(round(zoom))
//            }
//        }
//        
//        return attributes
//    }
}
