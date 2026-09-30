use tree_sitter_highlight::{
    HighlightConfiguration,
    HighlightEvent::{self, Source},
    Highlighter, HtmlRenderer,
};
use wasm_bindgen::prelude::wasm_bindgen;

enum Style {
    Color(&'static str),
    Bold,
    Italic,
    Underline,
}

impl Style {
    fn to_ansi(&self) -> String {
        match self {
            Self::Color(hex) => {
                let hex = hex.trim_start_matches("#");
                let r = u16::from_str_radix(&hex[0..2], 16).unwrap();
                let g = u16::from_str_radix(&hex[2..4], 16).unwrap();
                let b = u16::from_str_radix(&hex[4..6], 16).unwrap();
                format!("38;2;{r};{g};{b}")
            }
            Self::Bold => "1".into(),
            Self::Italic => "3".into(),
            Self::Underline => "4".into(),
        }
    }
    fn to_ansi_slice(styles: &[Self]) -> String {
        let mut output: String = "\x1b[".into();
        for (i, s) in styles.iter().enumerate() {
            if i > 0 {
                output += ";";
            }
            output.push_str(&s.to_ansi());
        }
        output += "m";
        output
    }
    fn to_css(&self) -> String {
        match self {
            Self::Color(hex) => format!("color:{hex}"),
            Self::Bold => "font-weight:bold".into(),
            Self::Italic => "font-style:italic".into(),
            Self::Underline => "text-decoration:underline".into(),
        }
    }
    fn to_css_slice(styles: &[Self]) -> String {
        let mut output: String = "style=\"".into();
        for (i, s) in styles.iter().enumerate() {
            if i > 0 {
                output += ";";
            }
            output.push_str(&s.to_css());
        }
        output += "\"";
        output
    }
}

// TODO:
// *#title* -> make `#title` bold
const CAPTURES: [(&str, &[Style]); 25] = [
    ("comment", &[Style::Color("#74747c")]),
    ("keyword", &[Style::Color("#d73948")]),
    ("punctuation.keyword", &[Style::Color("#d73948")]),
    ("keyword", &[Style::Color("#d73948")]),
    ("string", &[Style::Color("#198810")]),
    ("function", &[Style::Color("#4b69c6")]),
    ("punctuation.function", &[Style::Color("#4b69c6")]),
    ("number", &[Style::Color("#b60157")]),
    ("ident.interp", &[Style::Color("#8b41b1")]),
    ("punctuation.interp", &[Style::Color("#8b41b1")]),
    ("boolean", &[Style::Color("#d73948")]),
    ("punctuation", &[]),
    ("constant.builtin", &[Style::Color("#d73948")]),
    ("constant", &[Style::Color("#8b41b1")]),
    ("emphasis.strong", &[Style::Bold]),
    ("punctuation.math", &[Style::Color("#198810")]),
    ("math.operator", &[Style::Color("#1d6c76")]),
    ("title", &[Style::Bold, Style::Underline]),
    ("label", &[Style::Color("#1d6c76")]),
    ("link_uri", &[Style::Underline]),
    ("punctuation.raw", &[Style::Color("#6b6b6f")]),
    ("text.raw", &[Style::Color("#6b6b6f")]),
    ("punctuation.list_marker", &[Style::Color("#8b41b1")]),
    ("text.term", &[Style::Bold]),
    ("emphasis", &[Style::Italic]),
];

#[wasm_bindgen(getter_with_clone)]
pub struct Output {
    pub ansi: String,
    pub html: String,
}

#[wasm_bindgen]
pub fn highlight(source: &str) -> Output {
    let mut config = HighlightConfiguration::new(
        tree_sitter_typst::LANGUAGE.into(),
        "Typst",
        tree_sitter_typst::HIGHLIGHTS_QUERY,
        tree_sitter_typst::INJECTIONS_QUERY,
        "",
    )
    .expect("Error creating HighlightConfiguration");
    config.configure(&CAPTURES.map(|c| c.0));

    let mut highlighter = Highlighter::new();
    let highlights = highlighter
        .highlight(&config, source.as_bytes(), None, None, |lang| match lang {
            "typ" | "typst" => Some(&config),
            _ => None,
        })
        .unwrap();
    let mut ansi_output = String::new();
    for event in highlights {
        match event.unwrap() {
            HighlightEvent::HighlightStart(h) => {
                println!("{}", CAPTURES[h.0].0);
                ansi_output.push_str(&Style::to_ansi_slice(CAPTURES[h.0].1))
            }
            Source { start, end } => ansi_output.push_str(&source[start..end]),
            HighlightEvent::HighlightEnd => ansi_output += "\x1b[0m",
        }
    }
    let mut highlighter = Highlighter::new();
    let highlights = highlighter
        .highlight(&config, source.as_bytes(), None, None, |lang| match lang {
            "typ" | "typst" => Some(&config),
            _ => None,
        })
        .unwrap();
    let mut html_renderer = HtmlRenderer::new();
    html_renderer
        .render(highlights, source.as_bytes(), &|h, out| {
            out.append(&mut Style::to_css_slice(CAPTURES[h.0].1).into_bytes());
        })
        .unwrap();
    Output {
        ansi: ansi_output,
        html: html_renderer.lines().collect::<String>(),
    }
}
