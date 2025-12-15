//
//  NSColor+List.swift
//
//  Created on 07.10.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftCommons
import SwiftUI

extension NSColor {
    /// Slate
    public static let slate50 = NSColor(hex: "#f8fafc")
    public static let slate100 = NSColor(hex: "#f1f5f9")
    public static let slate200 = NSColor(hex: "#e2e8f0")
    public static let slate300 = NSColor(hex: "#cbd5e1")
    public static let slate400 = NSColor(hex: "#94a3b8")
    public static let slate500 = NSColor(hex: "#64748b")
    public static let slate600 = NSColor(hex: "#475569")
    public static let slate700 = NSColor(hex: "#334155")
    public static let slate800 = NSColor(hex: "#1e293b")
    public static let slate900 = NSColor(hex: "#0f172a")
    public static let slate950 = NSColor(hex: "#020617")
    /// Gray
    public static let gray50 = NSColor(hex: "#f9fafb")
    public static let gray100 = NSColor(hex: "#f3f4f6")
    public static let gray200 = NSColor(hex: "#e5e7eb")
    public static let gray300 = NSColor(hex: "#d1d5db")
    public static let gray400 = NSColor(hex: "#9ca3af")
    public static let gray500 = NSColor(hex: "#6b7280")
    public static let gray600 = NSColor(hex: "#4b5563")
    public static let gray700 = NSColor(hex: "#374151")
    public static let gray800 = NSColor(hex: "#1f2937")
    public static let gray900 = NSColor(hex: "#111827")
    public static let gray950 = NSColor(hex: "#030712")
    /// Zinc
    public static let zinc50 = NSColor(hex: "#fafafa")
    public static let zinc100 = NSColor(hex: "#f4f4f5")
    public static let zinc200 = NSColor(hex: "#e4e4e7")
    public static let zinc300 = NSColor(hex: "#d4d4d8")
    public static let zinc400 = NSColor(hex: "#a1a1aa")
    public static let zinc500 = NSColor(hex: "#71717a")
    public static let zinc600 = NSColor(hex: "#52525b")
    public static let zinc700 = NSColor(hex: "#3f3f46")
    public static let zinc800 = NSColor(hex: "#27272a")
    public static let zinc900 = NSColor(hex: "#18181b")
    public static let zinc950 = NSColor(hex: "#09090b")
    /// Neutral
    public static let neutral50 = NSColor(hex: "#fafafa")
    public static let neutral100 = NSColor(hex: "#f5f5f5")
    public static let neutral200 = NSColor(hex: "#e5e5e5")
    public static let neutral300 = NSColor(hex: "#d4d4d4")
    public static let neutral400 = NSColor(hex: "#a3a3a3")
    public static let neutral500 = NSColor(hex: "#737373")
    public static let neutral600 = NSColor(hex: "#525252")
    public static let neutral700 = NSColor(hex: "#404040")
    public static let neutral800 = NSColor(hex: "#262626")
    public static let neutral900 = NSColor(hex: "#171717")
    public static let neutral950 = NSColor(hex: "#0a0a0a")
    /// Stone
    public static let stone50 = NSColor(hex: "#fafaf9")
    public static let stone100 = NSColor(hex: "#f5f5f4")
    public static let stone200 = NSColor(hex: "#e7e5e4")
    public static let stone300 = NSColor(hex: "#d6d3d1")
    public static let stone400 = NSColor(hex: "#a8a29e")
    public static let stone500 = NSColor(hex: "#78716c")
    public static let stone600 = NSColor(hex: "#57534e")
    public static let stone700 = NSColor(hex: "#44403c")
    public static let stone800 = NSColor(hex: "#292524")
    public static let stone900 = NSColor(hex: "#1c1917")
    public static let stone950 = NSColor(hex: "#0c0a09")
    /// Red
    public static let red50 = NSColor(hex: "#fef2f2")
    public static let red100 = NSColor(hex: "#fee2e2")
    public static let red200 = NSColor(hex: "#fecaca")
    public static let red300 = NSColor(hex: "#fca5a5")
    public static let red400 = NSColor(hex: "#f87171")
    public static let red500 = NSColor(hex: "#ef4444")
    public static let red600 = NSColor(hex: "#dc2626")
    public static let red700 = NSColor(hex: "#b91c1c")
    public static let red800 = NSColor(hex: "#991b1b")
    public static let red900 = NSColor(hex: "#7f1d1d")
    public static let red950 = NSColor(hex: "#450a0a")
    /// Orange
    public static let orange50 = NSColor(hex: "#fff7ed")
    public static let orange100 = NSColor(hex: "#ffedd5")
    public static let orange200 = NSColor(hex: "#fed7aa")
    public static let orange300 = NSColor(hex: "#fdba74")
    public static let orange400 = NSColor(hex: "#fb923c")
    public static let orange500 = NSColor(hex: "#f97316")
    public static let orange600 = NSColor(hex: "#ea580c")
    public static let orange700 = NSColor(hex: "#c2410c")
    public static let orange800 = NSColor(hex: "#9a3412")
    public static let orange900 = NSColor(hex: "#7c2d12")
    public static let orange950 = NSColor(hex: "#431407")
    /// Amber
    public static let amber50 = NSColor(hex: "#fffbeb")
    public static let amber100 = NSColor(hex: "#fef3c7")
    public static let amber200 = NSColor(hex: "#fde68a")
    public static let amber300 = NSColor(hex: "#fcd34d")
    public static let amber400 = NSColor(hex: "#fbbf24")
    public static let amber500 = NSColor(hex: "#f59e0b")
    public static let amber600 = NSColor(hex: "#d97706")
    public static let amber700 = NSColor(hex: "#b45309")
    public static let amber800 = NSColor(hex: "#92400e")
    public static let amber900 = NSColor(hex: "#78350f")
    public static let amber950 = NSColor(hex: "#451a03")
    /// Yellow
    public static let yellow50 = NSColor(hex: "#fefce8")
    public static let yellow100 = NSColor(hex: "#fef9c3")
    public static let yellow200 = NSColor(hex: "#fef08a")
    public static let yellow300 = NSColor(hex: "#fde047")
    public static let yellow400 = NSColor(hex: "#facc15")
    public static let yellow500 = NSColor(hex: "#eab308")
    public static let yellow600 = NSColor(hex: "#ca8a04")
    public static let yellow700 = NSColor(hex: "#a16207")
    public static let yellow800 = NSColor(hex: "#854d0e")
    public static let yellow900 = NSColor(hex: "#713f12")
    public static let yellow950 = NSColor(hex: "#422006")
    /// Lime
    public static let lime50 = NSColor(hex: "#f7fee7")
    public static let lime100 = NSColor(hex: "#ecfccb")
    public static let lime200 = NSColor(hex: "#d9f99d")
    public static let lime300 = NSColor(hex: "#bef264")
    public static let lime400 = NSColor(hex: "#a3e635")
    public static let lime500 = NSColor(hex: "#84cc16")
    public static let lime600 = NSColor(hex: "#65a30d")
    public static let lime700 = NSColor(hex: "#4d7c0f")
    public static let lime800 = NSColor(hex: "#3f6212")
    public static let lime900 = NSColor(hex: "#365314")
    public static let lime950 = NSColor(hex: "#1a2e05")
    /// Green
    public static let green50 = NSColor(hex: "#f0fdf4")
    public static let green100 = NSColor(hex: "#dcfce7")
    public static let green200 = NSColor(hex: "#bbf7d0")
    public static let green300 = NSColor(hex: "#86efac")
    public static let green400 = NSColor(hex: "#4ade80")
    public static let green500 = NSColor(hex: "#22c55e")
    public static let green600 = NSColor(hex: "#16a34a")
    public static let green700 = NSColor(hex: "#15803d")
    public static let green800 = NSColor(hex: "#166534")
    public static let green900 = NSColor(hex: "#14532d")
    public static let green950 = NSColor(hex: "#052e16")
    /// Emerald
    public static let emerald50 = NSColor(hex: "#ecfdf5")
    public static let emerald100 = NSColor(hex: "#d1fae5")
    public static let emerald200 = NSColor(hex: "#a7f3d0")
    public static let emerald300 = NSColor(hex: "#6ee7b7")
    public static let emerald400 = NSColor(hex: "#34d399")
    public static let emerald500 = NSColor(hex: "#10b981")
    public static let emerald600 = NSColor(hex: "#059669")
    public static let emerald700 = NSColor(hex: "#047857")
    public static let emerald800 = NSColor(hex: "#065f46")
    public static let emerald900 = NSColor(hex: "#064e3b")
    public static let emerald950 = NSColor(hex: "#022c22")
    /// Teal
    public static let teal50 = NSColor(hex: "#f0fdfa")
    public static let teal100 = NSColor(hex: "#ccfbf1")
    public static let teal200 = NSColor(hex: "#99f6e4")
    public static let teal300 = NSColor(hex: "#5eead4")
    public static let teal400 = NSColor(hex: "#2dd4bf")
    public static let teal500 = NSColor(hex: "#14b8a6")
    public static let teal600 = NSColor(hex: "#0d9488")
    public static let teal700 = NSColor(hex: "#0f766e")
    public static let teal800 = NSColor(hex: "#115e59")
    public static let teal900 = NSColor(hex: "#134e4a")
    public static let teal950 = NSColor(hex: "#042f2e")
    /// Cyan
    public static let cyan50 = NSColor(hex: "#ecfeff")
    public static let cyan100 = NSColor(hex: "#cffafe")
    public static let cyan200 = NSColor(hex: "#a5f3fc")
    public static let cyan300 = NSColor(hex: "#67e8f9")
    public static let cyan400 = NSColor(hex: "#22d3ee")
    public static let cyan500 = NSColor(hex: "#06b6d4")
    public static let cyan600 = NSColor(hex: "#0891b2")
    public static let cyan700 = NSColor(hex: "#0e7490")
    public static let cyan800 = NSColor(hex: "#155e75")
    public static let cyan900 = NSColor(hex: "#164e63")
    public static let cyan950 = NSColor(hex: "#083344")
    /// Sky
    public static let sky50 = NSColor(hex: "#f0f9ff")
    public static let sky100 = NSColor(hex: "#e0f2fe")
    public static let sky200 = NSColor(hex: "#bae6fd")
    public static let sky300 = NSColor(hex: "#7dd3fc")
    public static let sky400 = NSColor(hex: "#38bdf8")
    public static let sky500 = NSColor(hex: "#0ea5e9")
    public static let sky600 = NSColor(hex: "#0284c7")
    public static let sky700 = NSColor(hex: "#0369a1")
    public static let sky800 = NSColor(hex: "#075985")
    public static let sky900 = NSColor(hex: "#0c4a6e")
    public static let sky950 = NSColor(hex: "#082f49")
    /// Blue
    public static let blue50 = NSColor(hex: "#eff6ff")
    public static let blue100 = NSColor(hex: "#dbeafe")
    public static let blue200 = NSColor(hex: "#bfdbfe")
    public static let blue300 = NSColor(hex: "#93c5fd")
    public static let blue400 = NSColor(hex: "#60a5fa")
    public static let blue500 = NSColor(hex: "#3b82f6")
    public static let blue600 = NSColor(hex: "#2563eb")
    public static let blue700 = NSColor(hex: "#1d4ed8")
    public static let blue800 = NSColor(hex: "#1e40af")
    public static let blue900 = NSColor(hex: "#1e3a8a")
    public static let blue950 = NSColor(hex: "#172554")
    /// Indigo
    public static let indigo50 = NSColor(hex: "#eef2ff")
    public static let indigo100 = NSColor(hex: "#e0e7ff")
    public static let indigo200 = NSColor(hex: "#c7d2fe")
    public static let indigo300 = NSColor(hex: "#a5b4fc")
    public static let indigo400 = NSColor(hex: "#818cf8")
    public static let indigo500 = NSColor(hex: "#6366f1")
    public static let indigo600 = NSColor(hex: "#4f46e5")
    public static let indigo700 = NSColor(hex: "#4338ca")
    public static let indigo800 = NSColor(hex: "#3730a3")
    public static let indigo900 = NSColor(hex: "#312e81")
    public static let indigo950 = NSColor(hex: "#1e1b4b")
    /// Violet
    public static let violet50 = NSColor(hex: "#f5f3ff")
    public static let violet100 = NSColor(hex: "#ede9fe")
    public static let violet200 = NSColor(hex: "#ddd6fe")
    public static let violet300 = NSColor(hex: "#c4b5fd")
    public static let violet400 = NSColor(hex: "#a78bfa")
    public static let violet500 = NSColor(hex: "#8b5cf6")
    public static let violet600 = NSColor(hex: "#7c3aed")
    public static let violet700 = NSColor(hex: "#6d28d9")
    public static let violet800 = NSColor(hex: "#5b21b6")
    public static let violet900 = NSColor(hex: "#4c1d95")
    public static let violet950 = NSColor(hex: "#2e1065")
    /// Purple
    public static let purple50 = NSColor(hex: "#faf5ff")
    public static let purple100 = NSColor(hex: "#f3e8ff")
    public static let purple200 = NSColor(hex: "#e9d5ff")
    public static let purple300 = NSColor(hex: "#d8b4fe")
    public static let purple400 = NSColor(hex: "#c084fc")
    public static let purple500 = NSColor(hex: "#a855f7")
    public static let purple600 = NSColor(hex: "#9333ea")
    public static let purple700 = NSColor(hex: "#7e22ce")
    public static let purple800 = NSColor(hex: "#6b21a8")
    public static let purple900 = NSColor(hex: "#581c87")
    public static let purple950 = NSColor(hex: "#3b0764")
    /// Fuchsia
    public static let fuchsia50 = NSColor(hex: "#fdf4ff")
    public static let fuchsia100 = NSColor(hex: "#fae8ff")
    public static let fuchsia200 = NSColor(hex: "#f5d0fe")
    public static let fuchsia300 = NSColor(hex: "#f0abfc")
    public static let fuchsia400 = NSColor(hex: "#e879f9")
    public static let fuchsia500 = NSColor(hex: "#d946ef")
    public static let fuchsia600 = NSColor(hex: "#c026d3")
    public static let fuchsia700 = NSColor(hex: "#a21caf")
    public static let fuchsia800 = NSColor(hex: "#86198f")
    public static let fuchsia900 = NSColor(hex: "#701a75")
    public static let fuchsia950 = NSColor(hex: "#4a044e")
    /// Pink
    public static let pink50 = NSColor(hex: "#fdf2f8")
    public static let pink100 = NSColor(hex: "#fce7f3")
    public static let pink200 = NSColor(hex: "#fbcfe8")
    public static let pink300 = NSColor(hex: "#f9a8d4")
    public static let pink400 = NSColor(hex: "#f472b6")
    public static let pink500 = NSColor(hex: "#ec4899")
    public static let pink600 = NSColor(hex: "#db2777")
    public static let pink700 = NSColor(hex: "#be185d")
    public static let pink800 = NSColor(hex: "#9d174d")
    public static let pink900 = NSColor(hex: "#831843")
    public static let pink950 = NSColor(hex: "#500724")
    /// Rose
    public static let rose50 = NSColor(hex: "#fff1f2")
    public static let rose100 = NSColor(hex: "#ffe4e6")
    public static let rose200 = NSColor(hex: "#fecdd3")
    public static let rose300 = NSColor(hex: "#fda4af")
    public static let rose400 = NSColor(hex: "#fb7185")
    public static let rose500 = NSColor(hex: "#f43f5e")
    public static let rose600 = NSColor(hex: "#e11d48")
    public static let rose700 = NSColor(hex: "#be123c")
    public static let rose800 = NSColor(hex: "#9f1239")
    public static let rose900 = NSColor(hex: "#881337")
    public static let rose950 = NSColor(hex: "#4c0519")
    /// Groups By Color Type
    public static let slate: [NSColor] = [slate50, slate100, slate200, slate300, slate400, slate500, slate600, slate700, slate800, slate900, slate950]
    public static let gray: [NSColor] = [gray50, gray100, gray200, gray300, gray400, gray500, gray600, gray700, gray800, gray900, gray950]
    public static let zinc: [NSColor] = [zinc50, zinc100, zinc200, zinc300, zinc400, zinc500, zinc600, zinc700, zinc800, zinc900, zinc950]
    public static let neutral: [NSColor] = [neutral50, neutral100, neutral200, neutral300, neutral400, neutral500, neutral600, neutral700, neutral800, neutral900, neutral950]
    public static let stone: [NSColor] = [stone50, stone100, stone200, stone300, stone400, stone500, stone600, stone700, stone800, stone900, stone950]
    public static let red: [NSColor] = [red50, red100, red200, red300, red400, red500, red600, red700, red800, red900, red950]
    public static let orange: [NSColor] = [orange50, orange100, orange200, orange300, orange400, orange500, orange600, orange700, orange800, orange900, orange950]
    public static let amber: [NSColor] = [amber50, amber100, amber200, amber300, amber400, amber500, amber600, amber700, amber800, amber900, amber950]
    public static let yellow: [NSColor] = [yellow50, yellow100, yellow200, yellow300, yellow400, yellow500, yellow600, yellow700, yellow800, yellow900, yellow950]
    public static let lime: [NSColor] = [lime50, lime100, lime200, lime300, lime400, lime500, lime600, lime700, lime800, lime900, lime950]
    public static let green: [NSColor] = [green50, green100, green200, green300, green400, green500, green600, green700, green800, green900, green950]
    public static let emerald: [NSColor] = [emerald50, emerald100, emerald200, emerald300, emerald400, emerald500, emerald600, emerald700, emerald800, emerald900, emerald950]
    public static let teal: [NSColor] = [teal50, teal100, teal200, teal300, teal400, teal500, teal600, teal700, teal800, teal900, teal950]
    public static let cyan: [NSColor] = [cyan50, cyan100, cyan200, cyan300, cyan400, cyan500, cyan600, cyan700, cyan800, cyan900, cyan950]
    public static let sky: [NSColor] = [sky50, sky100, sky200, sky300, sky400, sky500, sky600, sky700, sky800, sky900, sky950]
    public static let blue: [NSColor] = [blue50, blue100, blue200, blue300, blue400, blue500, blue600, blue700, blue800, blue900, blue950]
    public static let indigo: [NSColor] = [indigo50, indigo100, indigo200, indigo300, indigo400, indigo500, indigo600, indigo700, indigo800, indigo900, indigo950]
    public static let violet: [NSColor] = [violet50, violet100, violet200, violet300, violet400, violet500, violet600, violet700, violet800, violet900, violet950]
    public static let purple: [NSColor] = [purple50, purple100, purple200, purple300, purple400, purple500, purple600, purple700, purple800, purple900, purple950]
    public static let fuchsia: [NSColor] = [fuchsia50, fuchsia100, fuchsia200, fuchsia300, fuchsia400, fuchsia500, fuchsia600, fuchsia700, fuchsia800, fuchsia900, fuchsia950]
    public static let pink: [NSColor] = [pink50, pink100, pink200, pink300, pink400, pink500, pink600, pink700, pink800, pink900, pink950]
    public static let rose: [NSColor] = [rose50, rose100, rose200, rose300, rose400, rose500, rose600, rose700, rose800, rose900, rose950]
    public static let groupsByType: [String: [NSColor]] = [
        "slate": slate,
        "gray": gray,
        "zinc": zinc,
        "neutral": neutral,
        "stone": stone,
        "red": red,
        "orange": orange,
        "amber": amber,
        "yellow": yellow,
        "lime": lime,
        "green": green,
        "emerald": emerald,
        "teal": teal,
        "cyan": cyan,
        "sky": sky,
        "blue": blue,
        "indigo": indigo,
        "violet": violet,
        "purple": purple,
        "fuchsia": fuchsia,
        "pink": pink,
        "rose": rose,
    ]

    /// Color group metadata with hue wheel ordering
    /// Ordered by color wheel: Red → Orange → Yellow → Green → Cyan → Blue → Purple → Pink → Grays
    public struct ColorGroup: Identifiable, Hashable, @unchecked Sendable {
        public let id: String
        public let name: String
        public let colors: [NSColor]
        public let primaryColor: NSColor // The 500 shade for preview

        public init(id: String, name: String, colors: [NSColor]) {
            self.id = id
            self.name = name
            self.colors = colors
            primaryColor = colors.count > 5 ? colors[5] : colors.first ?? .clear
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        public static func == (lhs: ColorGroup, rhs: ColorGroup) -> Bool {
            lhs.id == rhs.id
        }
    }

    /// Colors ordered by hue wheel position (warm → cool → grays)
    public static let colorGroupsOrdered: [ColorGroup] = [
        // Warm colors (Reds → Oranges → Yellows)
        ColorGroup(id: "red", name: "Red", colors: red),
        ColorGroup(id: "rose", name: "Rose", colors: rose),
        ColorGroup(id: "pink", name: "Pink", colors: pink),
        ColorGroup(id: "orange", name: "Orange", colors: orange),
        ColorGroup(id: "amber", name: "Amber", colors: amber),
        ColorGroup(id: "yellow", name: "Yellow", colors: yellow),
        // Green spectrum
        ColorGroup(id: "lime", name: "Lime", colors: lime),
        ColorGroup(id: "green", name: "Green", colors: green),
        ColorGroup(id: "emerald", name: "Emerald", colors: emerald),
        ColorGroup(id: "teal", name: "Teal", colors: teal),
        // Cool colors (Cyans → Blues → Purples)
        ColorGroup(id: "cyan", name: "Cyan", colors: cyan),
        ColorGroup(id: "sky", name: "Sky", colors: sky),
        ColorGroup(id: "blue", name: "Blue", colors: blue),
        ColorGroup(id: "indigo", name: "Indigo", colors: indigo),
        ColorGroup(id: "violet", name: "Violet", colors: violet),
        ColorGroup(id: "purple", name: "Purple", colors: purple),
        ColorGroup(id: "fuchsia", name: "Fuchsia", colors: fuchsia),
        // Grayscale (at end)
        ColorGroup(id: "slate", name: "Slate", colors: slate),
        ColorGroup(id: "gray", name: "Gray", colors: gray),
        ColorGroup(id: "zinc", name: "Zinc", colors: zinc),
        ColorGroup(id: "neutral", name: "Neutral", colors: neutral),
        ColorGroup(id: "stone", name: "Stone", colors: stone),
    ]
    /// Groups By Color Depth
    public static let depth50: [NSColor] = [slate50, gray50, zinc50, neutral50, stone50, red50, orange50, amber50, yellow50, lime50, green50, emerald50, teal50, cyan50, sky50, blue50, indigo50, violet50, purple50, fuchsia50, pink50, rose50]
    public static let depth100: [NSColor] = [slate100, gray100, zinc100, neutral100, stone100, red100, orange100, amber100, yellow100, lime100, green100, emerald100, teal100, cyan100, sky100, blue100, indigo100, violet100, purple100, fuchsia100, pink100, rose100]
    public static let depth200: [NSColor] = [slate200, gray200, zinc200, neutral200, stone200, red200, orange200, amber200, yellow200, lime200, green200, emerald200, teal200, cyan200, sky200, blue200, indigo200, violet200, purple200, fuchsia200, pink200, rose200]
    public static let depth300: [NSColor] = [slate300, gray300, zinc300, neutral300, stone300, red300, orange300, amber300, yellow300, lime300, green300, emerald300, teal300, cyan300, sky300, blue300, indigo300, violet300, purple300, fuchsia300, pink300, rose300]
    public static let depth400: [NSColor] = [slate400, gray400, zinc400, neutral400, stone400, red400, orange400, amber400, yellow400, lime400, green400, emerald400, teal400, cyan400, sky400, blue400, indigo400, violet400, purple400, fuchsia400, pink400, rose400]
    public static let depth500: [NSColor] = [slate500, gray500, zinc500, neutral500, stone500, red500, orange500, amber500, yellow500, lime500, green500, emerald500, teal500, cyan500, sky500, blue500, indigo500, violet500, purple500, fuchsia500, pink500, rose500]
    public static let depth600: [NSColor] = [slate600, gray600, zinc600, neutral600, stone600, red600, orange600, amber600, yellow600, lime600, green600, emerald600, teal600, cyan600, sky600, blue600, indigo600, violet600, purple600, fuchsia600, pink600, rose600]
    public static let depth700: [NSColor] = [slate700, gray700, zinc700, neutral700, stone700, red700, orange700, amber700, yellow700, lime700, green700, emerald700, teal700, cyan700, sky700, blue700, indigo700, violet700, purple700, fuchsia700, pink700, rose700]
    public static let depth800: [NSColor] = [slate800, gray800, zinc800, neutral800, stone800, red800, orange800, amber800, yellow800, lime800, green800, emerald800, teal800, cyan800, sky800, blue800, indigo800, violet800, purple800, fuchsia800, pink800, rose800]
    public static let depth900: [NSColor] = [slate900, gray900, zinc900, neutral900, stone900, red900, orange900, amber900, yellow900, lime900, green900, emerald900, teal900, cyan900, sky900, blue900, indigo900, violet900, purple900, fuchsia900, pink900, rose900]
    public static let depth950: [NSColor] = [slate950, gray950, zinc950, neutral950, stone950, red950, orange950, amber950, yellow950, lime950, green950, emerald950, teal950, cyan950, sky950, blue950, indigo950, violet950, purple950, fuchsia950, pink950, rose950]
    public static let groupsByDepth: [UInt16: [NSColor]] = [
        50: depth50,
        100: depth100,
        200: depth200,
        300: depth300,
        400: depth400,
        500: depth500,
        600: depth600,
        700: depth700,
        800: depth800,
        900: depth900,
        950: depth950,
    ]
    /// All Colors
    public static let all: [NSColor] = groupsByType.values.flatMap(\.self)
}
