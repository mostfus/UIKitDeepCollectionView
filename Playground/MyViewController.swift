// Copyright © 2026 FinanceCore. All rights reserved.

import UIKit

struct MyCustomItem {
    let num: Int
}

final class MyViewController: UIViewController {
    private var collectionView: UICollectionView!
    
    private var items: [MyCustomItem] = {
        (0...10).map { num in
            MyCustomItem(num: num)
        }
    }()
    
    private lazy var sizes = [
        CGSize(width: 400, height: 100),
        CGSize(width: 50, height: 50),
        CGSize(width: 200, height: 100),
        CGSize(width: 11, height: 20)
    ]
    
    private lazy var circleButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("⬆️", for: .normal)
        
        button.addAction(UIAction(handler: { _ in
            self.handleButtonTap()
        }), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green.withAlphaComponent(0.5)
        configureCollectionView()
        setupUI()
        setupPinch()
    }
    
    private func handleButtonTap() {

    }
    
    private func configureCollectionView() {
        let layout = PinchLayout()
        layout.scrollDirection = .vertical
        let collettionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = collettionView

        collettionView.delegate = self
        collettionView.dataSource = self

        collettionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCell.reuseIdentifier)
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleButton)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            circleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            circleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupPinch() {
        let recognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        collectionView.addGestureRecognizer(recognizer)
    }
    
    @objc
    private func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let pinchedLayout = collectionView.collectionViewLayout as? PinchLayout else { return }
        
//        print(sender.state.rawValue)
        
        switch sender.state {
        case .possible:
            break
        case .began:
            let initialPinchPoint = sender.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: initialPinchPoint)
            if let indexPath {
                let cellIntialCenter = collectionView.cellForItem(at: indexPath)?.center
                pinchedLayout.originalCellCenter = cellIntialCenter
                UIView.animate(withDuration: 0.2) {
                    self.collectionView.cellForItem(at: indexPath)?.backgroundColor = .red
                }
            }
            pinchedLayout.pinchedCellPath = indexPath
        case .changed:
            pinchedLayout.pinchedCellScale = sender.scale
            pinchedLayout.pinchedCellCenter = sender.location(in: collectionView)
            collectionView.collectionViewLayout.invalidateLayout()
        case .ended, .cancelled:
            if let indexPath = pinchedLayout.pinchedCellPath {
                let cell = collectionView.cellForItem(at: indexPath)
                pinchedLayout.pinchedCellCenter = pinchedLayout.originalCellCenter
                pinchedLayout.pinchedCellScale = 1
                
                UIView.animate(withDuration: 0.2) {
                    cell?.backgroundColor = .green
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        case .failed, .recognized:
            break
        default:
            break
        }
    }
}

extension MyViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("UICollectionView.frame = \(collectionView.frame)")
        print("UICollectionView.bounds = \(collectionView.bounds)")
        print("ContentOffset: \(collectionView.contentOffset)")
        print("CollectionViewContentSize = \(collectionView.contentSize)")
        print("CollectionViewContentInset = \(collectionView.contentInset)")
    }
}

extension MyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        
        cell.configure(title: "\(items[indexPath.row].num)")
        cell.backgroundColor = .gray
        return cell
    }
}

//extension MyViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: collectionView.bounds.width, height: 100)
//    }
//}
