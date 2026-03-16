// Copyright © 2026 FinanceCore. All rights reserved.

import UIKit

final class LineViewController: UIViewController {
    private var collectionView: UICollectionView!
    
    private var cellCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setupUI()
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}

extension LineViewController: UICollectionViewDelegate {
    
}

extension LineViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        cell.configure(title: "\(indexPath.row)")
        cell.contentView.backgroundColor = .gray
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    
}

