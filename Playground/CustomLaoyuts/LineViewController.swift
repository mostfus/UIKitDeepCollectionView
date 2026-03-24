// Copyright © 2026 FinanceCore. All rights reserved.

import UIKit

final class LineViewController: UIViewController {
    private var collectionView: UICollectionView!
    
    private var dataSource: [Int] = {
        (1...20).map {
            $0
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setupUI()
        
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler)))
    }
    
    @objc
    private func tapHandler(_ sender: UITapGestureRecognizer) {
        print("Hello")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            self.collectionView.collectionViewLayout.invalidateLayout()
            print("UICollectionView.frame = \(collectionView.frame)")
            print("UICollectionView.bounds = \(collectionView.bounds)")
            print("ContentOffset: \(collectionView.contentOffset)")
            print("CollectionViewContentSize = \(collectionView.contentSize)")
            print("CollectionViewContentInset = \(collectionView.contentInset)")
        }
    }
    
    private func configureCollectionView() {
        let layout = LineCollectionViewLayout()
        let collettionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = collettionView

        collettionView.delegate = self
        collettionView.dataSource = self

        collettionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCell.reuseIdentifier)
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension LineViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("UICollectionView.frame = \(collectionView.frame)")
//        print("UICollectionView.bounds = \(collectionView.bounds)")
//        print("ContentOffset: \(collectionView.contentOffset)")
//        print("CollectionViewContentSize = \(collectionView.contentSize)")
//        print("CollectionViewContentInset = \(collectionView.contentInset)")
    }
    
}

extension LineViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        cell.configure(title: "\(dataSource[indexPath.row])")
        cell.contentView.backgroundColor = .gray
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates { [weak self] in
            guard let self else { return }
            dataSource.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }
    }
}

