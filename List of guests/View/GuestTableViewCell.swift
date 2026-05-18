import UIKit

class GuestTableViewCell: UITableViewCell {
    
    static let id = "GuestTableViewCell"
    private static let icons: [Int: (String)] = [
        1: ("person"),
        2: ("person.2"),
        3: ("person.3")]
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["1", "2", "3"])
        control.selectedSegmentIndex = 0
        control.setTitle("Один", forSegmentAt: 0)
        control.setTitle("Вдвоем", forSegmentAt: 1)
        control.setTitle("Втроем", forSegmentAt: 2)
        control.addTarget(self, action: #selector(didChangeNumberOfPeople(_:)), for: .valueChanged)
        return control
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .center
        imageView.tintColor = .black
        imageView.layer.cornerRadius = 20
        imageView.frame.size = CGSize(width: 30, height: 30)
        return imageView
    }()

    @objc func didChangeNumberOfPeople(_ sender: UISegmentedControl) {
        segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
        iconImageView.image = UIImage(systemName: Self.icons[sender.selectedSegmentIndex + 1] ?? "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.addSubviews([iconImageView, nameLabel, segmentedControl])
        setupConstraints()
    }
    
    func setup(with guest: Guest) {
        nameLabel.text = guest.name + " " + guest.sername
        iconImageView.image = UIImage(systemName: Self.icons[guest.count] ?? "")
        segmentedControl.selectedSegmentIndex = guest.count - 1
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,
                                               constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -10),
            segmentedControl.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                    multiplier: 0.45),
            segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
