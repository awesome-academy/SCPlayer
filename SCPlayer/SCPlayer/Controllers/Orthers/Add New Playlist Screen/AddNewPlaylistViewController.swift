//
//  AddNewPlaylistViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 19/05/2021.
//

import UIKit

final class AddNewPlaylistViewController: UIViewController {

    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var createButton: UIButton!
    
    private var selfPlaylistName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        inputTextField.textAlignment = .center
        inputTextField.text = selfPlaylistName
    }
    
    @IBAction func didTapCreateButton(_ sender: UIButton) {
        let text = inputTextField.text ?? ""
        if !(text.isEmpty) {
            PlaylistEntity.shared.insertNewPlaylist(playlistName: text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    public func getData(playlistName: String) {
        selfPlaylistName = playlistName
    }
}
