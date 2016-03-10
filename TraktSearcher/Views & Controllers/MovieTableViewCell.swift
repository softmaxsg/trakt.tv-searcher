//
//  MovieTableViewCell.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class MovieTableViewCell: UITableViewCell
{
    static let minimalHeight = CGFloat(130)

    private (set) var titleLabel: UILabel?
    private (set) var overviewLabel: UILabel?
    private (set) var yearLabel: UILabel?
    private (set) var movieImageView: UIImageView?

    @available(*, unavailable) required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCell()
    }

    func update(movie: MovieInfoViewModelData)
    {
        self.titleLabel?.text = movie.title
        self.overviewLabel?.text = movie.overview
        self.yearLabel?.text = movie.year > 0 ? String(movie.year) : nil

        let placeholderImage = UIImage(named: "MoviePosterPlaceholder")
        if let imageUrl = movie.imageUrl {
            self.movieImageView?.af_setImageWithURL(imageUrl, placeholderImage: placeholderImage)
        } else {
            self.movieImageView?.image = placeholderImage
        }
    }

    override func prepareForReuse()
    {
        super.prepareForReuse()

        self.movieImageView?.af_cancelImageRequest()
    }
}

extension MovieTableViewCell
{
    private static let imageViewSize = CGSize(width: 60, height: 90)
    private static let horizontalMargin = CGFloat(20)
    private static let verticalMargin = CGFloat(8)

    private func configureCell()
    {
        self.backgroundColor = UIColor.clearColor()

        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        self.titleLabel = titleLabel

        let overviewLabel = UILabel(frame: CGRect.zero)
        overviewLabel.backgroundColor = UIColor.clearColor()
        overviewLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        overviewLabel.numberOfLines = 0
        self.overviewLabel = overviewLabel

        let yearLabel = UILabel(frame: CGRect.zero)
        yearLabel.backgroundColor = UIColor.clearColor()
        yearLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        yearLabel.textAlignment = .Center
        self.yearLabel = yearLabel

        let movieImageView = UIImageView(frame: CGRect.zero)
        movieImageView.backgroundColor = UIColor.clearColor()
        self.movieImageView = movieImageView

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(overviewLabel)
        self.contentView.addSubview(yearLabel)
        self.contentView.addSubview(movieImageView)

        movieImageView.snp_makeConstraints { movieImageView in
            movieImageView.size.equalTo(self.dynamicType.imageViewSize)
            movieImageView.top.equalTo(self.contentView.snp_top).offset(self.dynamicType.verticalMargin)
            movieImageView.leading.equalTo(self.contentView.snp_leading).offset(self.dynamicType.horizontalMargin)
        }

        yearLabel.snp_makeConstraints { yearLabel in
            yearLabel.leading.equalTo(movieImageView)
            yearLabel.trailing.equalTo(movieImageView)
            yearLabel.top.equalTo(movieImageView.snp_bottom).offset(self.dynamicType.verticalMargin)
            yearLabel.bottom.lessThanOrEqualTo(self.contentView.snp_bottom).inset(self.dynamicType.verticalMargin)
        }

        titleLabel.snp_makeConstraints { titleLabel in
            titleLabel.top.equalTo(self.contentView.snp_top).offset(self.dynamicType.verticalMargin)
            titleLabel.leading.equalTo(movieImageView.snp_trailing).offset(self.dynamicType.horizontalMargin)
            titleLabel.trailing.equalTo(self.contentView.snp_trailing).inset(self.dynamicType.horizontalMargin)
        }

        overviewLabel.snp_makeConstraints { overviewLabel in
            overviewLabel.top.equalTo(titleLabel.snp_bottom).offset(self.dynamicType.verticalMargin)
            overviewLabel.leading.equalTo(titleLabel.snp_leading)
            overviewLabel.trailing.equalTo(titleLabel.snp_trailing)
            overviewLabel.bottom.equalTo(self.contentView.snp_bottom).inset(self.dynamicType.verticalMargin)
        }
    }
}
