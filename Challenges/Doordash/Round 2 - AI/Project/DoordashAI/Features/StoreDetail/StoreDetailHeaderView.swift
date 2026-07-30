//
//  StoreDetailHeaderView.swift
//  DoordashAI
//

import UIKit

final class StoreDetailHeaderView: UIView {

    private let imageLoader: ImageLoading = ImageLoader.shared
    private var imageTask: Task<Void, Never>?

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        let textStack = UIStackView(arrangedSubviews: [deliveryFeeLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(coverImageView)
        addSubview(textStack)

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 160),

            textStack.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 12),
            textStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    func configure(with store: Store) {
        descriptionLabel.text = store.description
        deliveryFeeLabel.text = "Delivery: \(CurrencyFormatter.string(fromCents: store.deliveryFeeCents))"

        imageTask?.cancel()
        coverImageView.image = nil
        guard let url = store.coverImageURL else { return }
        imageTask = Task { [weak self] in
            guard let image = try? await self?.imageLoader.loadImage(from: url) else { return }
            guard !Task.isCancelled else { return }
            self?.coverImageView.image = image
        }
    }
}
