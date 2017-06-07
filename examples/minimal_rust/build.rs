extern crate gcc;

fn main() {
    gcc::Config::new()
        .cpp(true)
        .flag("-std=c++11")
        .include("../../include")
        .file("../../sea-rt/seahorn.cpp")
        .compile("libseahorn.a");
}
