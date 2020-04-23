import UIKit

struct Keyboard {
    static func  hide(for textFields: UITextField...) {
        for tf in textFields {
            tf.resignFirstResponder()
        }
    }
}
