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
}
