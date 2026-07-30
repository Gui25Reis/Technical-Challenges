//
//  StoreCell.swift
//  DoordashAI
//

import UIKit

final class StoreCell: UITableViewCell {

    static let reuseIdentifier = "StoreCell"

    private let imageLoader: ImageLoading = ImageLoader.shared
    private var imageTask: Task<Void, Never>?

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    private let deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        coverImageView.image = nil
    }

    private func setUpViews() {
        let textStack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, deliveryFeeLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(coverImageView)
        contentView.addSubview(textStack)

        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            coverImageView.widthAnchor.constraint(equalToConstant: 72),
            coverImageView.heightAnchor.constraint(equalToConstant: 72),

            textStack.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with store: Store) {
        nameLabel.text = store.name
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
