//
//  MainViewController.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import ObjectiveC
import UIKit

class MainViewController: UITableViewController
{
    private enum SourceMode
    {
        case PopularMovies
        case SearchMovies
    }

    private static let titleText = "Most Popular Movies"

    private var searchController: UISearchController!

    private let popularMoviesDataSource: MoviesTableViewDataSource!
    private let searchMoviesDataSource: MoviesTableViewDataSource!

    weak var popularMoviesDelegate: PopularMoviesViewModelInput?
    weak var searchMoviesDelegate: SearchMoviesViewModelInput?

    private var currentSourceMode: SourceMode = .PopularMovies
    {
        didSet {
            let dataSource = self.currentDataSource

            if self.tableView.dataSource == nil || !self.tableView.dataSource!.isEqual(dataSource) {
                self.tableView.dataSource = dataSource
                self.tableView.reloadData()
            }
        }
    }

    private var currentDataSource: MoviesTableViewDataSource
    {
        get {
            switch self.currentSourceMode {
            case .PopularMovies: return self.popularMoviesDataSource
            case .SearchMovies: return self.searchMoviesDataSource
            }
        }
    }

    private var currentDelegate: MoviesViewModelInput?
    {
        get {
            switch self.currentSourceMode {
            case .PopularMovies: return self.popularMoviesDelegate
            case .SearchMovies: return self.searchMoviesDelegate
            }
        }
    }

    init(popularMoviesViewModel: MoviesViewModelData, searchMoviesViewModel: MoviesViewModelData)
    {
        self.popularMoviesDataSource = MoviesTableViewDataSource(viewModel: popularMoviesViewModel)
        self.searchMoviesDataSource = MoviesTableViewDataSource(viewModel: searchMoviesViewModel)

        super.init(style: .Grouped)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder)
    {
        self.popularMoviesDataSource = nil
        self.searchMoviesDataSource = nil

        super.init(coder: aDecoder)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.title = self.dynamicType.titleText

        self.configureBackground()
        self.configureTableView()
        self.configureSearchController()

        self.popularMoviesDelegate?.loadPopularMovies()
    }
}

// MARK: Configuring UI controls
extension MainViewController
{
    func configureBackground()
    {
        let backgroundView = UIImageView(image: UIImage(named: ImageAssets.Background.rawValue))
        backgroundView.contentMode = .ScaleAspectFill
        self.tableView.backgroundView = backgroundView
    }

    func configureTableView()
    {
        self.tableView.dataSource = self.currentDataSource
        self.tableView.registerClass(MovieTableViewCell.self, forCellReuseIdentifier: String(MovieTableViewCell))

        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .None

        self.tableView.estimatedRowHeight = MovieTableViewCell.minimalHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    func configureSearchController()
    {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        self.searchController = searchController

        self.tableView.tableHeaderView = searchController.searchBar
    }
}

// MARK: MoviesViewModelOutput
extension MainViewController: MoviesViewModelOutput
{
    func viewModelDidUpdate()
    {
        self.tableView.reloadData()
    }

    func viewModelLoadingDidFail(error: ErrorType)
    {
        self.tableView.reloadData()
    }
}

// MARK: UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchMoviesDelegate?.searchMovies(searchController.searchBar.text!)
        self.currentSourceMode = .SearchMovies
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        // This has to be posponed because updateSearchResultsForSearchController will be called right after this function
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.currentSourceMode = .PopularMovies
        }
    }
}

// MARK: Incremental data loading
extension MainViewController
{
    private struct AssociatedKeys
    {
        static var lastContentOffset = "lastContentOffset"
    }

    var lastContentOffset: CGPoint
    {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.lastContentOffset) as? NSValue else {
                return CGPoint.zero
            }

            return value.CGPointValue()
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.lastContentOffset, NSValue(CGPoint: value), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        guard let delegate = self.currentDelegate else {
            return
        }

        let contentOffset = scrollView.contentOffset
        if contentOffset.y > self.lastContentOffset.y {
            let nextBatchLoadingOffset = max(scrollView.contentSize.height - scrollView.bounds.height, 0);
            if contentOffset.y >= nextBatchLoadingOffset {
                if !delegate.loading && delegate.moreDataAvailable {
                    delegate.loadMoreData()
                }
            }
        }

        self.lastContentOffset = contentOffset
    }

    override func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        self.lastContentOffset = scrollView.contentOffset
    }
}
