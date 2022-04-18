//
//  Levels.swift
//  edu-app
//
//  Created by Filip Culig on 02.04.2022..
//

import Foundation
import SwiftUI

enum Levels: CaseIterable {
    case A
    case B
    case C
    case tvrdoC
    case mekoC
    case D
    case DZ
    case mekoD
    case E
    case F
    case G
    case H
    case I
    case J
    case K
    case L
    case LJ
    case M
    case N
    case NJ
    case O
    case P
    case R
    case S
    case SH
    case T
    case U
    case V
    case Z
    case ZH

    var results: [String] {
        switch self {
        case .A:
            return ["A"]
        case .B:
            return ["B"]
        case .C:
            return ["C", "c"]
        case .tvrdoC:
            return ["Č", "č"]
        case .mekoC:
            return ["Ć", "ć"]
        case .D:
            return ["D"]
        case .DZ:
            return ["DŽ"]
        case .mekoD:
            return ["Đ"]
        case .E:
            return ["E"]
        case .F:
            return ["F"]
        case .G:
            return ["G"]
        case .H:
            return ["H"]
        case .I:
            return ["I", "i"]
        case .J:
            return ["J", "j"]
        case .K:
            return ["K"]
        case .L:
            return ["L"]
        case .LJ:
            return ["LJ"]
        case .M:
            return ["M"]
        case .N:
            return ["N"]
        case .NJ:
            return ["NJ"]
        case .O:
            return ["O", "o"]
        case .P:
            return ["P", "p"]
        case .R:
            return ["R"]
        case .S:
            return ["S", "s"]
        case .SH:
            return ["Š", "š"]
        case .T:
            return ["T"]
        case .U:
            return ["U", "u"]
        case .V:
            return ["V", "v"]
        case .Z:
            return ["Z", "z"]
        case .ZH:
            return ["Ž", "ž"]
        }
    }

    var numberOfLines: Int {
        switch self {
        case .A:
            return 3
        case .B:
            return 3
        case .C:
            return 1
        case .tvrdoC:
            return 2
        case .mekoC:
            return 2
        case .D:
            return 2
        case .DZ:
            return 6
        case .mekoD:
            return 3
        case .E:
            return 4
        case .F:
            return 3
        case .G:
            return 2
        case .H:
            return 3
        case .I:
            return 1
        case .J:
            return 1
        case .K:
            return 3
        case .L:
            return 2
        case .LJ:
            return 3
        case .M:
            return 3
        case .N:
            return 3
        case .NJ:
            return 4
        case .O:
            return 1
        case .P:
            return 2
        case .R:
            return 3
        case .S:
            return 1
        case .SH:
            return 2
        case .T:
            return 2
        case .U:
            return 1
        case .V:
            return 2
        case .Z:
            return 3
        case .ZH:
            return 4
        }
    }

    var rawName: String {
        switch self {
        case .A:
            return "A"
        case .B:
            return "B"
        case .C:
            return "C"
        case .tvrdoC:
            return "Č"
        case .mekoC:
            return "Ć"
        case .D:
            return "D"
        case .DZ:
            return "DŽ"
        case .mekoD:
            return "Đ"
        case .E:
            return "E"
        case .F:
            return "F"
        case .G:
            return "G"
        case .H:
            return "H"
        case .I:
            return "I"
        case .J:
            return "J"
        case .K:
            return "K"
        case .L:
            return "L"
        case .LJ:
            return "LJ"
        case .M:
            return "M"
        case .N:
            return "N"
        case .NJ:
            return "NJ"
        case .O:
            return "O"
        case .P:
            return "P"
        case .R:
            return "R"
        case .S:
            return "S"
        case .SH:
            return "Š"
        case .T:
            return "T"
        case .U:
            return "U"
        case .V:
            return "V"
        case .Z:
            return "Z"
        case .ZH:
            return "Ž"
        }
    }

    var unlockedImage: Image {
        switch self {
        case .A:
            return Image("A-unlocked").resizable()
        case .B:
            return Image("A-unlocked").resizable()
        case .C:
            return Image("A-unlocked").resizable()
        case .tvrdoC:
            return Image("A-unlocked").resizable()
        case .mekoC:
            return Image("A-unlocked").resizable()
        case .D:
            return Image("A-unlocked").resizable()
        case .DZ:
            return Image("A-unlocked").resizable()
        case .mekoD:
            return Image("A-unlocked").resizable()
        case .E:
            return Image("A-unlocked").resizable()
        case .F:
            return Image("A-unlocked").resizable()
        case .G:
            return Image("A-unlocked").resizable()
        case .H:
            return Image("A-unlocked").resizable()
        case .I:
            return Image("A-unlocked").resizable()
        case .J:
            return Image("A-unlocked").resizable()
        case .K:
            return Image("A-unlocked").resizable()
        case .L:
            return Image("A-unlocked").resizable()
        case .LJ:
            return Image("A-unlocked").resizable()
        case .M:
            return Image("A-unlocked").resizable()
        case .N:
            return Image("A-unlocked").resizable()
        case .NJ:
            return Image("A-unlocked").resizable()
        case .O:
            return Image("A-unlocked").resizable()
        case .P:
            return Image("A-unlocked").resizable()
        case .R:
            return Image("A-unlocked").resizable()
        case .S:
            return Image("A-unlocked").resizable()
        case .SH:
            return Image("A-unlocked").resizable()
        case .T:
            return Image("A-unlocked").resizable()
        case .U:
            return Image("A-unlocked").resizable()
        case .V:
            return Image("A-unlocked").resizable()
        case .Z:
            return Image("A-unlocked").resizable()
        case .ZH:
            return Image("A-unlocked").resizable()
        }
    }

    var lockedImage: Image {
        switch self {
        case .A:
            return Image("A-locked").resizable()
        case .B:
            return Image("A-locked").resizable()
        case .C:
            return Image("A-locked").resizable()
        case .tvrdoC:
            return Image("A-locked").resizable()
        case .mekoC:
            return Image("A-locked").resizable()
        case .D:
            return Image("A-locked").resizable()
        case .DZ:
            return Image("A-locked").resizable()
        case .mekoD:
            return Image("A-locked").resizable()
        case .E:
            return Image("A-locked").resizable()
        case .F:
            return Image("A-locked").resizable()
        case .G:
            return Image("A-locked").resizable()
        case .H:
            return Image("A-locked").resizable()
        case .I:
            return Image("A-locked").resizable()
        case .J:
            return Image("A-locked").resizable()
        case .K:
            return Image("A-locked").resizable()
        case .L:
            return Image("A-locked").resizable()
        case .LJ:
            return Image("A-locked").resizable()
        case .M:
            return Image("A-locked").resizable()
        case .N:
            return Image("A-locked").resizable()
        case .NJ:
            return Image("A-locked").resizable()
        case .O:
            return Image("A-locked").resizable()
        case .P:
            return Image("A-locked").resizable()
        case .R:
            return Image("A-locked").resizable()
        case .S:
            return Image("A-locked").resizable()
        case .SH:
            return Image("A-locked").resizable()
        case .T:
            return Image("A-locked").resizable()
        case .U:
            return Image("A-locked").resizable()
        case .V:
            return Image("A-locked").resizable()
        case .Z:
            return Image("A-locked").resizable()
        case .ZH:
            return Image("A-locked").resizable()
        }
    }
}
