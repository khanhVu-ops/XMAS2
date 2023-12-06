//
//  Extension.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 19/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension SearchBar {
    var rxSearchText: Observable<String> {
        return tfSearch.rx.text.orEmpty.asObservable()
    }
    
    var rxSearchBegin: ControlEvent<()> {
        return tfSearch.rx.controlEvent(.editingDidBegin)
    }
    
    var rxSearchEnd: ControlEvent<()> {
        return tfSearch.rx.controlEvent(.editingDidEnd)
    }
}
