//
//  LSTableViewHelper.swift
//  LSBase
//
//  Created by zrf on 2021/7/21.
//  处理TableView解耦。
//  所有cell与cell中model都遵循对应的协议

import Foundation

//MARK: tableview中数据model需遵循的协议
public protocol LSCellItemProtocol{
    ///加载cell
    var cellForRowCallback: ((IndexPath) -> Void)? { get set }
    ///将要显示cell
    var willDisplayCallback: ((IndexPath) -> Void)? { get set }
    ///点击cell回调
    var didSelectCellCallback: ((IndexPath) -> Void)? { get set }
    ///绑定cell
    func bindCell() -> UITableViewCell.Type
    ///创建cell
    func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    ///cell高度
    func cellHeight() -> CGFloat
}
public extension LSCellItemProtocol {
    var cellForRowCallback: ((IndexPath) -> Void)? {
        get {
            return nil
        }
        set {
            
        }
    }
    var willDisplayCallback: ((IndexPath) -> Void)? {
        get {
            return nil
        }
        set {
            
        }
    }
    var didSelectCellCallback: ((IndexPath) -> Void)? {
        get {
            return nil
        }
        set {
            
        }
    }
    func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cellClass = bindCell()
        let identifier = String.init(describing: cellClass)
        var tableViewCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            tableViewCell = cell
        }else {
            tableViewCell = cellClass.init(style: .default, reuseIdentifier: identifier)
        }
        (tableViewCell as? LSCellProtocol)?.ls_setItem(self)
        return tableViewCell
    }
    ///高度
    func cellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- cell遵循的协议
public protocol LSCellProtocol {
    func ls_setItem(_ item: LSCellItemProtocol)
}


public class LSTableViewHelper: NSObject{
    public var dataSource = [LSCellItemProtocol]()
    private weak var delegate: UITableViewDelegate?
    public init(delegate: UITableViewDelegate? = nil) {
        self.delegate = delegate
    }
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) {
            return self
        }else if let delegate = delegate, delegate.responds(to: aSelector) {
            return delegate
        }
        return self
    }
    public override func responds(to aSelector: Selector!) -> Bool {
        if let delegate = delegate {
            return super.responds(to: aSelector) || delegate.responds(to: aSelector)
        }
        return super.responds(to: aSelector)
    }
    
    /**下面callback与cellItemProtocol功能类似，区别于：itemProtocol可用于一条一条处理，  此处用于批量处理*/
    ///加载cell。
    private var cellCallback: ((UITableViewCell, LSCellItemProtocol, IndexPath) -> Void)?
    ///将要显示cell
    private var displayCallback: ((LSCellItemProtocol, IndexPath) -> Void)?
    ///点击cell回调
    private var selectCallback: ((LSCellItemProtocol, IndexPath) -> Void)?
    public var rowHeight: CGFloat?
    
    @discardableResult
    public func cellForRow(_ closure:@escaping (UITableViewCell,LSCellItemProtocol,IndexPath) -> Void) -> Self {
        cellCallback = closure
        return self
    }
    @discardableResult
    public func willDisplay(_ closure:@escaping (LSCellItemProtocol,IndexPath) -> Void) -> Self {
        displayCallback = closure
        return self
    }
    @discardableResult
    public func selectRow(_ closure:@escaping (LSCellItemProtocol, IndexPath) -> Void) -> Self {
        selectCallback = closure
        return self
    }
}
// MARK: - ---UITableViewDelegate
extension LSTableViewHelper: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didSelectRowAt:))) {
            delegate.tableView!(tableView, didSelectRowAt: indexPath)
        }else {
            dataSource[indexPath.row].didSelectCellCallback?(indexPath)
            selectCallback?(dataSource[indexPath.row], indexPath)
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:heightForRowAt:))) {
            return delegate.tableView!(tableView, heightForRowAt: indexPath)
        }else {
            if (rowHeight != nil), dataSource[indexPath.row].cellHeight() != UITableView.automaticDimension{  //当全局设置了cell高度，并且每个item没有设置高，使用全局高
                return rowHeight!
            }
            return dataSource[indexPath.row].cellHeight()
        }
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:willDisplay:forRowAt:))) {
            delegate.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
        }else {
            dataSource[indexPath.row].willDisplayCallback?(indexPath)
            displayCallback?(dataSource[indexPath.row], indexPath)
        }
    }
}
//MARK: - ---UITableViewDataSource
extension LSTableViewHelper: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count < 1 {
            fatalError("LSTableViewHelper.dataSource必须定义")
        }
        return dataSource.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        let cell = item.dequeueReusableCell(tableView: tableView, indexPath: indexPath)
        item.cellForRowCallback?(indexPath)
        cellCallback?(cell, dataSource[indexPath.row], indexPath)
        return cell
    }
}
