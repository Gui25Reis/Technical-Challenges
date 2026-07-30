//
//  StoreListFeaturedHeaderView.swift
//  DoordashAI
//

import UIKit

protocol StoreListFeaturedHeaderViewDelegate: AnyObject {
    func featuredHeaderView(_ view: StoreListFeaturedHeaderView, didSelectStoreAt index: Int)
}

/// Header da lista de lojas: stack horizontal só com as capas das 3 primeiras lojas.
/// Tocar numa imagem navega pro detalhe da loja, igual tocar numa linha da lista.
final class StoreListFeaturedHeaderView: UIView {

    weak var delegate: StoreListFeaturedHeaderViewDelegate?

    private let imageLoader: ImageLoading = ImageLoader.shared
    private var imageLoadTasks: [Task<Void, Never>] = []

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    func configure(with stores: [Store]) {
        imageLoadTasks.forEach { $0.cancel() }
        imageLoadTasks.removeAll()
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for (index, store) in stores.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .secondarySystemBackground
            imageView.layer.cornerRadius = 8
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
            stackView.addArrangedSubview(imageView)

            guard let url = store.coverImageURL else { continue }
            let task = Task { [weak self, weak imageView] in
                guard let image = try? await self?.imageLoader.loadImage(from: url) else { return }
                guard !Task.isCancelled else { return }
                imageView?.image = image
            }
            imageLoadTasks.append(task)
        }
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view else { return }
        delegate?.featuredHeaderView(self, didSelectStoreAt: imageView.tag)
    }
}
