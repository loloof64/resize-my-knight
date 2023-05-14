slint::include_modules!();

fn main() -> Result<(), slint::PlatformError> {
    let ui = App::new();
    ui?.run()
}
